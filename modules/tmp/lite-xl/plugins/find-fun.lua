-- mod-version:3
-- Orginal Author: Daniel36191
-- Find replace ui

local core = require "core"
local common = require "core.common"
local command = require "core.command"
local config = require "core.config"
local keymap = require "core.keymap"
local style = require "core.style"
local RootView = require "core.rootview"
local DocView = require "core.docview"
local search = require "core.doc.search"

config.plugins.findbar = config.plugins.findbar or {}

style.findbar_match = style.findbar_match or { 255, 205, 84, 80 }
style.findbar_match_active = style.findbar_match_active or { 255, 160, 40, 150 }

local scale = SCALE or 1
local PATHSEP = package.config:sub(1, 1)
local unpack = table.unpack or _G.unpack

local function opt(name, default)
    local v = config.plugins.findbar[name]
    if v == nil then return default end
    return v
end

local CHAR_PATTERN = "([%z\1-\127\194-\244][\128-\191]*)"

local function char_count(s)
    local n = 0
    for _ in s:gmatch(CHAR_PATTERN) do n = n + 1 end
    return n
end

local function char_sub(s, a, b)
    if s == "" then return "" end
    if b and b < a then return "" end
    local out = {}
    local i = 0
    for ch in s:gmatch(CHAR_PATTERN) do
        i = i + 1
        if i >= a and (not b or i <= b) then out[#out + 1] = ch end
    end
    return table.concat(out)
end

local function point_in(x, y, px, py, pw, ph)
    return x >= px and x <= px + pw and y >= py and y <= py + ph
end

local TextBox = {}
TextBox.__index = TextBox

local function new_box(text)
    local n = char_count(text or "")
    return setmetatable({ text = text or "", pos = n + 1, sel = 1 }, TextBox)
end

function TextBox:sel_range()
    local a, b = self.sel, self.pos
    if a == b then return nil end
    if a > b then return b, a end
    return a, b
end

function TextBox:erase()
    local a, b = self:sel_range()
    if not a then return false end
    self.text = char_sub(self.text, 1, a - 1) .. char_sub(self.text, b)
    self.pos = a
    self.sel = a
    return true
end

function TextBox:insert(ch)
    self:erase()
    self.text = char_sub(self.text, 1, self.pos - 1) .. ch .. char_sub(self.text, self.pos)
    self.pos = self.pos + char_count(ch)
    self.sel = self.pos
end

function TextBox:backspace()
    if self:erase() then return end
    if self.pos <= 1 then return end
    self.text = char_sub(self.text, 1, self.pos - 2) .. char_sub(self.text, self.pos)
    self.pos = self.pos - 1
    self.sel = self.pos
end

function TextBox:delete()
    if self:erase() then return end
    local n = char_count(self.text)
    if self.pos > n then return end
    self.text = char_sub(self.text, 1, self.pos - 1) .. char_sub(self.text, self.pos + 1)
    self.sel = self.pos
end

function TextBox:move(n)
    local max = char_count(self.text) + 1
    self.pos = math.max(1, math.min(max, self.pos + n))
    self.sel = self.pos
end

function TextBox:home()
    self.pos = 1
    self.sel = 1
end

function TextBox:to_end()
    self.pos = char_count(self.text) + 1
    self.sel = self.pos
end

local function skip_spaces_back(s, p)
    while p > 1 and s:sub(p - 1, p - 1) == " " do p = p - 1 end
    return p
end

local function skip_word_back(s, p)
    while p > 1 and s:sub(p - 1, p - 1) ~= " " do p = p - 1 end
    return p
end

local function skip_spaces_fwd(s, p)
    local n = #s
    while p <= n and s:sub(p, p) == " " do p = p + 1 end
    return p
end

local function skip_word_fwd(s, p)
    local n = #s
    while p <= n and s:sub(p, p) ~= " " do p = p + 1 end
    return p
end

function TextBox:left_word()
    self.pos = skip_word_back(self.text, skip_spaces_back(self.text, self.pos))
    self.sel = self.pos
end

function TextBox:right_word()
    self.pos = skip_word_fwd(self.text, skip_spaces_fwd(self.text, self.pos))
    self.sel = self.pos
end

function TextBox:backspace_word()
    if self:erase() then return end
    if self.pos <= 1 then return end
    local s = skip_word_back(self.text, skip_spaces_back(self.text, self.pos))
    self.text = self.text:sub(1, s - 1) .. self.text:sub(self.pos)
    self.pos = s
    self.sel = s
end

function TextBox:delete_word()
    if self:erase() then return end
    local n = #self.text
    if self.pos > n then return end
    local e = skip_word_fwd(self.text, skip_spaces_fwd(self.text, self.pos))
    self.text = self.text:sub(1, self.pos - 1) .. self.text:sub(e)
    self.sel = self.pos
end

function TextBox:select_all()
    self.sel = 1
    self.pos = char_count(self.text) + 1
end

function TextBox:paste()
    if self:erase() then return end
    if system.get_clipboard then
        local clip = system.get_clipboard()
        if clip then
            clip = clip:gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n", " ")
            for ch in clip:gmatch(CHAR_PATTERN) do self:insert(ch) end
        end
    end
end

function TextBox:copy()
    local a, b = self:sel_range()
    local text
    if a then
        text = char_sub(self.text, a, b - 1)
    else
        text = self.text
    end
    if #text > 0 and system.set_clipboard then system.set_clipboard(text) end
end

local function compile_regex(q, case_sensitive)
    local ok, re = pcall(regex.compile, q, case_sensitive and "" or "i")
    if not ok then return nil end
    return re
end

local function compute_matches(doc, q, case_sensitive, is_regex)
    local per, flat = {}, {}
    if not doc or q == "" then return per, flat end
    local re
    local ts = q
    if is_regex then
        re = compile_regex(q, case_sensitive)
        if not re then return per, flat end
    elseif not case_sensitive then
        ts = q:lower()
    end
    local cap = 30000
    for line = 1, #doc.lines do
        local subject = doc.lines[line]
        if not is_regex and not case_sensitive then subject = subject:lower() end
        local line_matches = {}
        local s = 1
        while s <= #subject do
            local a, b
            if is_regex then
                a, b = re:cmatch(subject, s)
                if not a then break end
                b = b - 1
            else
                a, b = subject:find(ts, s, true)
                if not a then break end
            end
            local len = b - a + 1
            if len > 0 then
                line_matches[#line_matches + 1] = { col = a, len = len }
                flat[#flat + 1] = { line = line, col = a, len = len }
            end
            s = b + 1
            if len <= 0 then s = a + 1 end
        end
        if line_matches[1] then
            per[line] = line_matches
            if #flat >= cap then break end
        end
    end
    return per, flat
end

local fb = {}

fb.mode = nil
fb.doc = nil
fb.docview = nil
fb.orig = nil
fb.committed = false
fb.case = false
fb.regex = false
fb.highlight = true
fb.replace_visible = false
fb.focus = "search"
fb.find_box = new_box("")
fb.rbox = new_box("")
fb.pbox = new_box("")
fb.per = {}
fb.flat = {}
fb.current = 0

fb.last_query = ""
fb.last_regex = false
fb.last_case = false

fb.pres = {}
fb.pmatch_total = 0
fb.psel = 0
fb.pscroll = 0
fb.psearching = false
fb.pgen = 0
fb.pdebounce = 0

fb.widget = nil
fb.buttons = {}

local function is_open()
    return fb.mode ~= nil
end

local function active_box()
    if fb.mode == "find" then
        return fb.focus == "replace" and fb.rbox or fb.find_box
    end
    return fb.pbox
end

function fb:is_open() return fb.mode ~= nil end

local function current_docview()
    local v = core.active_view
    if v and v:is(DocView) then return v end
    return nil
end

function fb:jump_match(i)
    local m = self.flat[i]
    if not m then return end
    self.doc:set_selection(m.line, m.col, m.line, m.col + m.len)
    self.current = i
    if self.docview then self.docview:scroll_to_line(m.line, true, true) end
    core.redraw = true
end

function fb:run_find()
    if self.find_box.text == "" then
        self.per, self.flat, self.current = {}, {}, 0
        if self.doc then self.doc.find_matches = nil end
        core.redraw = true
        return
    end
    self.per, self.flat = compute_matches(self.doc, self.find_box.text, self.case, self.regex)
    self.current = 0
    if self.doc then self.doc.find_matches = (self.highlight and self.per or nil) end
    if #self.flat > 0 then self:jump_match(1) else core.redraw = true end
end

function fb:step(i_delta)
    local n = #self.flat
    if n == 0 then return end
    local i = (self.current - 1 + i_delta + n) % n + 1
    self.committed = true
    self:jump_match(i)
end

function fb:open_find(with_replace)
    local dv = current_docview()
    if not dv then return end
    self:close()
    self.mode = "find"
    self.doc = dv.doc
    self.docview = dv
    self.orig = { self.doc:get_selection() }
    self.committed = false
    self.replace_visible = not not with_replace
    self.focus = with_replace and "replace" or "search"
    self.query_was_selection = false

    local l1, c1, l2, c2 = self.doc:get_selection()
    local text = ""
    if l1 == l2 then text = self.doc:get_text(l1, c1, l2, c2) end
    if text ~= "" then
        text = text:gsub("\n", "")
        if #text > 512 then text = text:sub(1, 512) end
        self.find_box = new_box(text)
        self.find_box:select_all()
        self.query_was_selection = true
    elseif self.last_query ~= "" then
        self.find_box = new_box(self.last_query)
        self.find_box:select_all()
    else
        self.find_box = new_box("")
    end
    if with_replace then
        self.rbox = new_box(self.doc:get_text(l1, c1, l2, c2):gsub("\n", ""))
        if #self.rbox.text > 512 then self.rbox.text = self.rbox.text:sub(1, 512) end
        self.rbox:select_all()
    end
    self.case = self.last_case
    self.regex = self.last_regex
    self:run_find()
end

function fb:close()
    if self.mode == nil then return end
    if self.mode == "find" then
        if self.doc then
            self.doc.find_matches = nil
            if not self.committed and self.orig then
                self.doc:set_selection(unpack(self.orig))
                if self.docview then self.docview:scroll_to_make_visible(unpack(self.orig)) end
            end
        end
    end
    self.mode = nil
    self.per, self.flat, self.current = {}, {}, 0
    self.widget = nil
    self.pres = {}
    self.psel, self.pscroll = 0, 0
    self.psearching = false
    self.pgen = self.pgen + 1
    core.redraw = true
end

function fb:enter(reverse)
    if self.mode == "find" then
        if self.focus == "replace" then
            self:replace_current()
        else
            self:step(reverse and -1 or 1)
        end
    elseif self.mode == "project" then
        if self.psel > 0 then
            self:proj_open(self.psel)
        else
            self:schedule_project_search(0)
        end
    end
end

function fb:toggle_case()
    self.case = not self.case
    if self.mode == "project" then
        self:schedule_project_search(0)
    else
        self:run_find()
    end
end

function fb:toggle_regex()
    self.regex = not self.regex
    if self.mode == "project" then
        self:schedule_project_search(0)
    else
        self:run_find()
    end
end

function fb:toggle_highlight()
    self.highlight = not self.highlight
    if self.doc then
        self.doc.find_matches = (self.highlight and self.per or nil)
    end
    core.redraw = true
end

function fb:toggle_replace()
    self.replace_visible = not self.replace_visible
    if self.replace_visible and self.rbox.text == "" then
        self.rbox = new_box("")
    end
    if self.replace_visible then self.focus = "replace" end
    core.redraw = true
end

local function raw_replace_range(doc, line, col, old_len, new)
    doc:remove(line, col, line, col + old_len)
    doc:insert(line, col, new)
end

function fb:replace_current()
    local box = self.rbox
    local i = self.current
    local m = self.flat[i]
    if not m then return end
    raw_replace_range(self.doc, m.line, m.col, m.len, box.text)
    self.committed = true
    self:run_find()
    self:jump_match(i)
end

function fb:replace_all()
    if self.mode ~= "find" or #self.flat == 0 then return end
    local new = self.rbox.text
    local doc = self.doc

    for i = #self.flat, 1, -1 do
        local m = self.flat[i]
        raw_replace_range(doc, m.line, m.col, m.len, new)
    end
    core.log("findbar: replaced %d instance(s)", #self.flat)
    self:run_find()
end

function fb:apply()
    if self.mode ~= "find" then return end

    if not self.replace_visible then
        self:toggle_replace()
        return
    end
    self:replace_all()
end

function fb:repeat_find(dv, reverse)
    local q = self.last_query
    if not q or q == "" then
        core.error("No find to continue from")
        return
    end
    local doc = dv.doc
    local l1, c1, l2, c2 = doc:get_selection(true)
    local line1, col1, line2, col2 = search.find(doc,
        reverse and l1 or l2, reverse and c1 or c2, q,
        { wrap = true, no_case = not self.last_case, regex = self.last_regex, reverse = reverse })
    if line1 then
        doc:set_selection(line2, col2, line1, col1)
        dv:scroll_to_line(line2, true)
    else
        core.error("Couldn't find %q", q)
    end
end

function fb:open_project()
    self:close()
    self.mode = "project"
    self.psel, self.pscroll = 0, 0
    self.pmatch_total = 0
    self.case = self.last_case
    self.regex = self.last_regex

    local dv = current_docview()
    local text = ""
    if dv and dv.doc then
        local l1, c1, l2, c2 = dv.doc:get_selection()
        if l1 == l2 then text = dv.doc:get_text(l1, c1, l2, c2) end
    end
    if text ~= "" and #text < 512 then
        self.pbox = new_box(text)
        self.pbox:select_all()
    else
        self.pbox = new_box("")
    end
    self:run_project_search()
end

function fb:schedule_project_search(delay)
    delay = delay or 0.15
    self.pdebounce = self.pdebounce + 1
    local id = self.pdebounce
    core.add_thread(function()
        coroutine.yield(delay)
        if id == self.pdebounce and self.mode == "project" then
            self:run_project_search()
        end
    end)
end

local function build_line_matcher(query, is_regex, case_sensitive)
    if query == "" then return nil end
    if is_regex then
        local re = compile_regex(query, case_sensitive)
        if not re then return nil end
        return function(line_text)
            local s, e = re:cmatch(line_text, 1)
            return s, e and (e - 1)
        end, re
    end
    local ts = case_sensitive and query or query:lower()
    return function(line_text)
        return line_text:find(ts, 1, true)
    end
end

function fb:run_project_search()
    self.psearching = true
    self.pgen = self.pgen + 1
    local gen = self.pgen
    local query = self.pbox.text
    self.pres = {}
    self.psel, self.pscroll = 0, 0
    self.pmatch_total = 0

    core.add_thread(function()
        local matcher = build_line_matcher(query, self.regex, self.case)
        if not matcher then
            if gen == self.pgen then
                self.psearching = false
                core.redraw = true
            end
            return
        end
        local max = opt("max_proj_matches", 5000)
        local rows = {}
        local total = 0
        local searching_files = 0
        local project_files = core.project_files_number()

        local function scan_file(dir_name, file)
            if total >= max then return end
            searching_files = searching_files + 1
            local rel = (dir_name == core.project_dir and "" or (dir_name .. PATHSEP))
                .. file.filename
            local abs = dir_name .. "/" .. file.filename
            local fp = io.open(abs)
            if not fp then return end
            local line_no = 0
            local file_rows = {}
            for line_text in fp:lines() do
                line_no = line_no + 1
                local s, e = matcher(line_text)
                if s then
                    local start_col = math.max(s - 60, 1)
                    local preview = (start_col > 1 and "..." or "")
                    preview = preview .. line_text:sub(start_col, 300 + start_col)
                    if #line_text > 300 + start_col then preview = preview .. "..." end
                    file_rows[#file_rows + 1] = {
                        type = "match",
                        rel = rel,
                        abs = abs,
                        line = line_no,
                        col = s,
                        text = preview,
                    }
                    total = total + 1
                    if total >= max then break end
                end
            end
            fp:close()
            if file_rows[1] then
                rows[#rows + 1] = { type = "file", name = rel, count = #file_rows }
                for _, r in ipairs(file_rows) do rows[#rows + 1] = r end
            end
        end

        for dir_name, file in core.get_project_files() do
            if gen ~= self.pgen then return end
            if file.type == "file" then scan_file(dir_name, file) end
            if searching_files % 20 == 0 then coroutine.yield() end
            if total >= max then break end
        end

        if gen ~= self.pgen then return end
        self.pres = rows
        self.pmatch_total = total
        self.psearching = false
        core.redraw = true
    end)
end

function fb:proj_open(row_index)
    local row = self.pres[row_index]
    if not row or row.type ~= "match" then return end
    core.try(function()
        local dv = core.root_view:open_doc(core.open_doc(row.rel))
        core.root_view.root_node:update_layout()
        dv.doc:set_selection(row.line, row.col, row.line, row.col + 1)
        dv:scroll_to_line(row.line, false, true)
    end)
end

local function next_match_row(i)
    local rows = fb.pres
    for i0 = i + 1, #rows do
        if rows[i0].type == "match" then return i0 end
    end
    if fb.pmatch_total > 0 then
        for i0 = 1, #rows do
            if rows[i0].type == "match" then return i0 end
        end
    end
    return 0
end

local function prev_match_row(i)
    local rows = fb.pres
    for i0 = i - 1, 1, -1 do
        if rows[i0].type == "match" then return i0 end
    end
    if fb.pmatch_total > 0 then
        for i0 = #rows, 1, -1 do
            if rows[i0].type == "match" then return i0 end
        end
    end
    return 0
end

function fb:proj_move(dir)
    local rows = self.pres
    if #rows == 0 then return end
    local next
    if dir > 0 then
        next = next_match_row(self.psel)
    else
        next = prev_match_row(self.psel == 0 and (#rows + 1) or self.psel)
    end
    if next > 0 then
        self.psel = next
        self:proj_ensure_visible(next)
    end
    core.redraw = true
end

local PROJ_ROW_H
local PROJ_PAD

function fb:proj_row_y(index)
    local y = self.widget and (self.widget.list_y or 0) or 0
    return y + (index - 1) * PROJ_ROW_H
end

function fb:proj_ensure_visible(index)
    local L = self.widget
    if not L then return end
    local y = self:proj_row_y(index) - L.list_y
    if y < 0 then
        self.pscroll = math.max(0, self.pscroll + y)
    else
        local area_h = L.list_h
        if y > area_h - PROJ_ROW_H then
            self.pscroll = self.pscroll + (y - (area_h - PROJ_ROW_H))
        end
    end
    local max = math.max(0, self:proj_content_h() - L.list_h)
    self.pscroll = math.max(0, math.min(self.pscroll, max))
end

function fb:proj_content_h()
    return #self.pres * PROJ_ROW_H
end

function fb:proj_wheel(delta_y)
    local step = PROJ_ROW_H * 3
    local L = self.widget
    local max = math.max(0, self:proj_content_h() - (L and L.list_h or 0))
    self.pscroll = math.max(0, math.min(max, self.pscroll - delta_y * step))
    core.redraw = true
end

function fb:after_edit(box)
    if self.mode == "find" then
        if box == self.find_box then
            self:run_find()
        end
    elseif self.mode == "project" then
        if box == self.pbox then
            self:schedule_project_search(0.15)
        end
    end
end

function fb:box_move(n)
    local b = active_box(); b:move(n); core.redraw = true
end

function fb:box_home()
    local b = active_box(); b:home(); core.redraw = true
end

function fb:box_end()
    local b = active_box(); b:to_end(); core.redraw = true
end

function fb:box_left_word()
    local b = active_box(); b:left_word(); core.redraw = true
end

function fb:box_right_word()
    local b = active_box(); b:right_word(); core.redraw = true
end

function fb:box_backspace()
    local b = active_box(); b:backspace(); core.redraw = true; self:after_edit(b)
end

function fb:box_delete()
    local b = active_box(); b:delete(); core.redraw = true; self:after_edit(b)
end

function fb:box_backspace_word()
    local b = active_box(); b:backspace_word(); core.redraw = true; self:after_edit(b)
end

function fb:box_delete_word()
    local b = active_box(); b:delete_word(); core.redraw = true; self:after_edit(b)
end

function fb:box_select_all()
    local b = active_box(); b:select_all(); core.redraw = true
end

function fb:box_paste()
    local b = active_box(); b:paste(); core.redraw = true; self:after_edit(b)
end

function fb:box_copy()
    active_box():copy()
end

function fb:on_text_input(text)
    local b = active_box()
    for ch in text:gmatch(CHAR_PATTERN) do b:insert(ch) end
    core.redraw = true
    self:after_edit(b)
end

function fb:up()
    if self.mode == "find" then
        self:step(-1)
    else
        self:proj_move(-1)
    end
end

function fb:down()
    if self.mode == "find" then
        self:step(1)
    else
        self:proj_move(1)
    end
end

function fb:cycle_focus()
    if self.mode ~= "find" or not self.replace_visible then return end
    self.focus = (self.focus == "search") and "replace" or "search"
    core.redraw = true
end

local function draw_text_box(box, x, y, w, h, focused, placeholder, suffix)
    local font = style.font
    local fh = font:get_height()
    local pad = 8 * scale
    renderer.draw_rect(x, y, w, h, style.background)
    renderer.draw_rect(x, y + h - 1, w, 2, focused and style.accent or style.dim)
    local tx = x + pad
    local ty = y + math.floor((h - fh) / 2)
    local text = box.text
    local n = char_count(text)
    if n == 0 then
        renderer.draw_text(font, placeholder, tx, ty, style.dim)
        if suffix then
            local sw = font:get_width(suffix)
            renderer.draw_text(font, suffix, x + w - pad - sw, ty, style.dim)
        end
        return
    end
    core.push_clip_rect(x, y, w, h)
    local right_margin = x + w - pad
    if suffix then right_margin = right_margin - font:get_width(suffix) - 6 * scale end
    local shift = 0
    local caret_x = tx + font:get_width(char_sub(text, 1, box.pos - 1))
    if caret_x > right_margin then
        shift = caret_x - right_margin
        tx = tx - shift
        caret_x = right_margin
    end
    local a, b = box:sel_range()
    if a then
        local sx = tx + font:get_width(char_sub(text, 1, a - 1))
        local ex = tx + font:get_width(char_sub(text, 1, b - 1))
        sx = math.max(x, sx)
        ex = math.min(right_margin, ex)
        if ex > sx then
            renderer.draw_rect(sx, y + 3, ex - sx, h - 6, { style.accent[1], style.accent[2], style.accent[3], 70 })
        end
    end
    renderer.draw_text(font, text, tx, ty, style.text)
    if focused and math.floor(system.get_time() * 2.5) % 2 == 0 then
        renderer.draw_rect(caret_x, y + 4, 2, h - 8, style.caret)
    end
    core.pop_clip_rect()
    if suffix then
        local sw = font:get_width(suffix)
        local sx = x + w - pad - sw
        renderer.draw_rect(sx - 4, y, sw + 8, h, style.background)
        renderer.draw_text(font, suffix, sx, ty, style.dim)
    end
end

local function draw_button(id, x, y, w, h, label, active)
    fb.buttons[id] = { x = x, y = y, w = w, h = h }
    renderer.draw_rect(x, y, w, h, active and style.accent or style.background)
    common.draw_text(style.font,
        active and style.background or style.text, label, "center", x, y, w, h)
end

local function caret_from_mouse(box, mx, x)
    local font = style.font
    local px = x + 8 * scale
    local text = box.text
    local n = char_count(text)
    local best, bestd = 1, math.huge
    for p = 1, n + 1 do
        local cx = px + font:get_width(char_sub(text, 1, p - 1))
        local d = math.abs(cx - mx)
        if d < bestd then bestd, best = d, p end
        if cx > mx then break end
    end
    return best
end

function fb:draw_find_widget()
    local sw, sh = core.root_view.size.x, core.root_view.size.y
    local font = style.font
    local fh = font:get_height()
    local pad = 8 * scale
    local mr = 12 * scale
    local gap = 6 * scale
    local label_h = fh
    local label_gap = 3 * scale
    local row_gap = 8 * scale
    local input_h = fh + 16 * scale
    local w = math.min(math.max(sw * opt("find_width", 0.46), 340 * scale), sw - 2 * mr - 40 * scale)
    local iw = w - 2 * pad
    local x = sw - w - mr
    local y = mr

    local inputs = {}
    inputs[#inputs + 1] = { id = "search", box = self.find_box, placeholder = "Find", label = "Find" }
    if self.replace_visible then
        inputs[#inputs + 1] = { id = "replace", box = self.rbox, placeholder = "Replace", label = "Replace" }
    end
    local n_inputs = #inputs
    local row_step = label_h + label_gap + input_h + row_gap

    local input_y0 = y + pad
    local last_box_bottom = input_y0 + (n_inputs - 1) * row_step + label_h + label_gap + input_h
    local tb_y = last_box_bottom + row_gap
    local apply_y = tb_y + input_h + row_gap
    local h = apply_y + input_h + pad - y

    self.widget = { x = x, y = y, w = w, h = h }
    fb.buttons = {}

    renderer.draw_rect(x, y, w, h, style.background3)
    renderer.draw_rect(x, y, w, 1, style.divider)
    renderer.draw_rect(x, y + h - 1, w, 1, style.divider)
    renderer.draw_rect(x, y, 1, h, style.divider)
    renderer.draw_rect(x + w - 1, y, 1, h, style.divider)

    local count_str = ""
    if self.find_box.text ~= "" then
        count_str = self.flat[1] and string.format("%d/%d", self.current, #self.flat) or "0"
    end

    for i, inp in ipairs(inputs) do
        local row_top = input_y0 + (i - 1) * row_step
        renderer.draw_text(font, inp.label, x + pad, row_top, style.dim)
        local iy = row_top + label_h + label_gap
        local suffix = (inp.id == "search") and count_str or nil
        draw_text_box(inp.box, x + pad, iy, iw, input_h,
            self.focus == inp.id, inp.placeholder, suffix)
        fb.buttons["box." .. inp.id] = { x = x + pad, y = iy, w = iw, h = input_h }
    end

    local tb = {
        { id = "prev",    label = "<" },
        { id = "next",    label = ">" },
        { id = "case",    label = "Aa", active = self.case },
        { id = "regex",   label = ".*", active = self.regex },
        { id = "hl",      label = "Hi", active = self.highlight },
        { id = "replace", label = "R",  active = self.replace_visible },
        { id = "close",   label = "X" },
    }
    local n = #tb
    local sep = 4 * scale
    local bw = (iw - (n - 1) * sep) / n
    local bx = x + pad
    for i, b in ipairs(tb) do
        draw_button(b.id, bx, tb_y, bw, input_h, b.label, b.active)
        bx = bx + bw + sep
    end

    local apply_label = (#self.flat > 0) and ("Apply (%d)"):format(#self.flat) or "Apply"
    draw_button("apply", x + pad, apply_y, iw, input_h, apply_label, #self.flat > 0)
end

function fb:draw_project_widget()
    local sw, sh = core.root_view.size.x, core.root_view.size.y
    local font = style.font
    local fh = font:get_height()
    local pad = 8 * scale
    local mr = 10 * scale
    local input_h = fh + 16 * scale
    local w = math.min(math.max(sw * opt("proj_width", 0.38), 300 * scale), sw - 2 * mr - 40 * scale)
    local x = mr
    local y = mr
    local h = sh - 2 * mr

    self.widget = { x = x, y = y, w = w, h = h }
    fb.buttons = {}

    renderer.draw_rect(x, y, w, h, style.background3)
    local btn = input_h - 6 * scale
    local bx = x + w - pad - btn
    draw_button("pclose", bx, y + pad, btn, btn, "X", false)
    draw_button("pcase", bx - btn - 4 * scale, y + pad, btn, btn, "Aa", self.case)
    draw_button("pregex", bx - 2 * (btn + 4 * scale), y + pad, btn, btn, ".*", self.regex)

    local title_y = y + pad
    local title = self.psearching and "Searching..." or "Results"
    renderer.draw_text(font, title, x + pad, title_y + (btn - fh) / 2, style.dim)

    local pbox_y = y + pad + btn + 4 * scale
    draw_text_box(self.pbox, x + pad, pbox_y, w - 2 * pad, input_h,
        true, "Search project", nil)
    fb.buttons["pbox"] = { x = x + pad, y = pbox_y, w = w - 2 * pad, h = input_h }

    local area_y = pbox_y + input_h + 6 * scale
    local files_n = 0
    for _, row in ipairs(self.pres) do
        if row.type == "file" then files_n = files_n + 1 end
    end
    local summary
    if self.pmatch_total > 0 then
        summary = string.format("%d matches in %d files", self.pmatch_total, files_n)
    elseif self.psearching then
        summary = "Scanning..."
    elseif self.pbox.text == "" then
        summary = "Type to search the project"
    else
        summary = "No matches"
    end
    renderer.draw_text(font, summary, x + pad, area_y, style.dim)
    area_y = area_y + fh + 4 * scale
    renderer.draw_rect(x + pad, area_y, w - 2 * pad, 1, style.divider)
    area_y = area_y + 4 * scale

    local list_y = area_y
    local list_h = y + h - list_y - 4 * scale
    self.widget.list_y = list_y
    self.widget.list_h = list_h
    PROJ_ROW_H = fh + 8 * scale
    PROJ_PAD = pad

    local max_scroll = math.max(0, self:proj_content_h() - list_h)
    self.pscroll = math.max(0, math.min(self.pscroll, max_scroll))
    if max_scroll > 0 and #self.pres > 0 then
        local th = list_h * list_h / self:proj_content_h()
        local sy = list_y + (list_h - th) * (self.pscroll / max_scroll)
        renderer.draw_rect(x + w - 4 * scale, sy, 3 * scale, th, style.scrollbar)
    end

    core.push_clip_rect(x, list_y, w, list_h)
    if #self.pres == 0 then
        renderer.draw_text(font, self.psearching and "Searching..." or "No matches found",
            x + pad, list_y + 4, style.dim)
    else
        local start_row = math.floor(self.pscroll / PROJ_ROW_H) + 1
        local y0 = list_y - (self.pscroll % PROJ_ROW_H)
        local idx = start_row
        local yy = y0 + (start_row - 1) * PROJ_ROW_H
        while idx <= #self.pres and yy < list_y + list_h do
            local row = self.pres[idx]
            local row_x = x + pad
            local row_w = w - 2 * pad
            if row.type == "file" then
                renderer.draw_rect(row_x, yy, row_w, PROJ_ROW_H, style.line_highlight)
                renderer.draw_text(font, row.name, row_x, yy + (PROJ_ROW_H - fh) / 2, style.text)
                local cs = string.format(" %d", row.count)
                renderer.draw_text(font, cs, x + w - pad - font:get_width(cs), yy + (PROJ_ROW_H - fh) / 2, style.accent)
            else
                if idx == self.psel then
                    renderer.draw_rect(row_x, yy, row_w, PROJ_ROW_H,
                        { style.accent[1], style.accent[2], style.accent[3], 55 })
                end
                local lx = row_x + 14 * scale
                local num = string.format("%d:", row.line)
                renderer.draw_text(font, num, lx, yy + (PROJ_ROW_H - fh) / 2, style.dim)
                lx = lx + font:get_width(num) + 8 * scale
                self:draw_preview_row(font, row.text, lx, yy + (PROJ_ROW_H - fh) / 2,
                    x + w - pad - lx, idx == self.psel)
            end
            idx = idx + 1
            yy = yy + PROJ_ROW_H
        end
    end
    core.pop_clip_rect()
end

function fb:draw_preview_row(font, text, tx, ty, w, selected)
    local color = selected and style.accent or style.text
    if self.regex then
        renderer.draw_text(font, text, tx, ty, color)
        return
    end
    local q = self.pbox.text:lower()
    if q == "" then
        renderer.draw_text(font, text, tx, ty, color)
        return
    end
    local idx = 1
    local px = tx
    local n = #text
    core.push_clip_rect(tx, ty, w, style.font:get_height())
    while true do
        local s, e = text:lower():find(q, idx, true)
        if not s then
            if px <= tx + w then
                renderer.draw_text(font, text:sub(idx), px, ty, style.dim)
            end
            break
        end
        if s > idx then
            renderer.draw_text(font, text:sub(idx, s - 1), px, ty, style.dim)
            px = px + font:get_width(text:sub(idx, s - 1))
        end
        renderer.draw_text(font, text:sub(s, e), px, ty, color)
        px = px + font:get_width(text:sub(s, e))
        idx = e + 1
        if idx > n then break end
    end
    core.pop_clip_rect()
end

function fb:draw()
    if self.mode == "find" then
        self:draw_find_widget()
    elseif self.mode == "project" then
        self:draw_project_widget()
    end
end

function fb:widget_rect()
    local L = self.widget
    if not L then return nil end
    return L.x, L.y, L.w, L.h
end

function fb:handle_find_click(mx, my, clicks)
    for id, r in pairs(fb.buttons) do
        if point_in(mx, my, r.x, r.y, r.w, r.h) then
            if id == "box.search" or id == "box.replace" then
                local b = (id == "box.replace") and self.rbox or self.find_box
                self.focus = (id == "box.replace") and "replace" or "search"
                b.pos = caret_from_mouse(b, mx, r.x)
                b.sel = b.pos
            elseif id == "prev" then
                self:step(-1)
            elseif id == "next" then
                self:step(1)
            elseif id == "case" then
                self:toggle_case()
            elseif id == "regex" then
                self:toggle_regex()
            elseif id == "hl" then
                self:toggle_highlight()
            elseif id == "replace" then
                self:toggle_replace()
            elseif id == "apply" then
                self:apply()
            elseif id == "close" then
                self:close()
            end
            core.redraw = true
            return true
        end
    end
    self.focus = "search"
    core.redraw = true
    return true
end

function fb:handle_project_click(mx, my, clicks)
    for id, r in pairs(fb.buttons) do
        if point_in(mx, my, r.x, r.y, r.w, r.h) then
            if id == "pbox" then
                self.pbox.pos = caret_from_mouse(self.pbox, mx, r.x)
                self.pbox.sel = self.pbox.pos
            elseif id == "pcase" then
                self.toggle_case()
            elseif id == "pregex" then
                self.toggle_regex()
            elseif id == "pclose" then
                self:close()
            end
            core.redraw = true
            return true
        end
    end
    local L = self.widget
    if L then
        local row = math.floor((my - L.list_y + self.pscroll) / PROJ_ROW_H) + 1
        if row >= 1 and row <= #self.pres then
            self.psel = row
            self:proj_ensure_visible(row)
            if self.pres[row].type == "match" and clicks == 1 then
                self:proj_open(row)
            end
            core.redraw = true
            return true
        end
    end
    core.redraw = true
    return true
end

local root_draw = RootView.draw
function RootView:draw(...)
    root_draw(self, ...)
    if fb.mode then fb:draw() end
end

local root_text_input = RootView.on_text_input
function RootView:on_text_input(...)
    if fb.mode then
        fb:on_text_input(...)
        return
    end
    return root_text_input(self, ...)
end

local root_mouse_pressed = RootView.on_mouse_pressed
function RootView:on_mouse_pressed(button, x, y, clicks)
    if fb.mode then
        local L = fb.widget
        if L and point_in(x, y, L.x, L.y, L.w, L.h) then
            if fb.mode == "find" then
                fb:handle_find_click(x, y, clicks)
            else
                fb:handle_project_click(x, y, clicks)
            end
            return true
        end
        fb:close()
    end
    return root_mouse_pressed(self, button, x, y, clicks)
end

local root_mouse_released = RootView.on_mouse_released
function RootView:on_mouse_released(button, x, y)
    if fb.mode then return true end
    return root_mouse_released(self, button, x, y)
end

local root_mouse_moved = RootView.on_mouse_moved
function RootView:on_mouse_moved(x, y, dx, dy)
    if fb.mode then
        local L = fb.widget
        if L and point_in(x, y, L.x, L.y, L.w, L.h) then
            return true
        end
    end
    return root_mouse_moved(self, x, y, dx, dy)
end

local root_mouse_wheel = RootView.on_mouse_wheel
function RootView:on_mouse_wheel(...)
    if fb.mode then
        local x, y = self.mouse.x, self.mouse.y
        local L = fb.widget
        if L and point_in(x, y, L.x, L.y, L.w, L.h) then
            if fb.mode == "project" then
                fb:proj_wheel((select(1, ...)) or 0)
            end
            return true
        end
    end
    return root_mouse_wheel(self, ...)
end

local raw_draw_line_text = DocView.draw_line_text
function DocView:draw_line_text(line, x, y)
    local matches = self.doc and self.doc.find_matches
    local per = matches and matches[line]
    if per then
        local font = self:get_font()
        local lh = self:get_line_height()
        local text = self.doc.lines[line]
        local active_line, active_col, active_len
        if fb.mode == "find" and fb.doc == self.doc and fb.flat[fb.current] then
            local m = fb.flat[fb.current]
            active_line, active_col, active_len = m.line, m.col, m.len
        end
        core.push_clip_rect(x, y, self.size.x, lh)
        for _, m in ipairs(per) do
            local px = x + font:get_width(text:sub(1, m.col - 1))
            local pw = font:get_width(text:sub(m.col, m.col + m.len - 1))
            if pw > 0 then
                local col = (line == active_line and m.col == active_col and m.len == active_len)
                    and style.findbar_match_active or style.findbar_match
                renderer.draw_rect(px, y, pw, lh, col)
            end
        end
        core.pop_clip_rect()
    end
    return raw_draw_line_text(self, line, x, y)
end

local function docview_predicate()
    local v = core.active_view
    return v ~= nil and v:is(DocView)
end

command.add(docview_predicate, {
    ["find-replace:find"] = function()
        fb:open_find(false)
    end,
    ["find-replace:replace"] = function()
        fb:open_find(true)
    end,
})

command.add(function()
    if fb.last_query == "" then return false end
    local v = core.active_view
    if not v or not v:is(DocView) then return false end
    return true, v
end, {
    ["find-replace:repeat-find"] = function(dv)
        fb:repeat_find(dv, false)
    end,
    ["find-replace:previous-find"] = function(dv)
        fb:repeat_find(dv, true)
    end,
})

command.add(nil, {
    ["project-search:find"] = function()
        fb:open_project()
    end,
})

command.add(is_open, {
    ["findbar:close"] = function() fb:close() end,
    ["findbar:enter"] = function() fb:enter(false) end,
    ["findbar:enter-reverse"] = function() fb:enter(true) end,
    ["findbar:up"] = function() fb:up() end,
    ["findbar:down"] = function() fb:down() end,
    ["findbar:cycle"] = function() fb:cycle_focus() end,
    ["findbar:left"] = function() fb:box_move(-1) end,
    ["findbar:right"] = function() fb:box_move(1) end,
    ["findbar:home"] = function() fb:box_home() end,
    ["findbar:end-key"] = function() fb:box_end() end,
    ["findbar:left-word"] = function() fb:box_left_word() end,
    ["findbar:right-word"] = function() fb:box_right_word() end,
    ["findbar:backspace"] = function() fb:box_backspace() end,
    ["findbar:delete"] = function() fb:box_delete() end,
    ["findbar:backspace-word"] = function() fb:box_backspace_word() end,
    ["findbar:delete-word"] = function() fb:box_delete_word() end,
    ["findbar:select-all"] = function() fb:box_select_all() end,
    ["findbar:paste"] = function() fb:box_paste() end,
    ["findbar:copy"] = function() fb:box_copy() end,
    ["findbar:toggle-case"] = function() fb:toggle_case() end,
    ["findbar:toggle-regex"] = function() fb:toggle_regex() end,
    ["findbar:toggle-replace"] = function() fb:toggle_replace() end,
    ["findbar:replace-all"] = function() fb:replace_all() end,
    ["findbar:apply"] = function() fb:apply() end,
})

keymap.add {
    ["escape"] = { "findbar:close" },
    ["return"] = { "findbar:enter" },
    ["shift+return"] = { "findbar:enter-reverse" },
    ["up"] = { "findbar:up" },
    ["down"] = { "findbar:down" },
    ["tab"] = { "findbar:cycle" },
    ["shift+tab"] = { "findbar:cycle" },
    ["left"] = { "findbar:left" },
    ["right"] = { "findbar:right" },
    ["home"] = { "findbar:home" },
    ["end"] = { "findbar:end-key" },
    ["ctrl+left"] = { "findbar:left-word" },
    ["ctrl+right"] = { "findbar:right-word" },
    ["backspace"] = { "findbar:backspace" },
    ["delete"] = { "findbar:delete" },
    ["ctrl+backspace"] = { "findbar:backspace-word" },
    ["ctrl+delete"] = { "findbar:delete-word" },
    ["ctrl+a"] = { "findbar:select-all" },
    ["ctrl+v"] = { "findbar:paste" },
    ["shift+insert"] = { "findbar:paste" },
    ["ctrl+c"] = { "findbar:copy" },
    ["ctrl+return"] = { "findbar:replace-all" },
    ["ctrl+i"] = { "findbar:toggle-case" },
    ["ctrl+shift+i"] = { "findbar:toggle-regex" },
}

core.add_thread(function()
    while true do
        coroutine.yield(0.05)
        if fb.mode then core.redraw = true end
    end
end)
return fb
