-- mod-version:3
-- Orginal Author: Daniel36191
-- Highlight unsaved tabs

-- config.plugins.unsaved_tabs.color = { 235, 155, 65, 255 }
-- config.plugins.unsaved_tabs.recolor_text = true
-- config.plugins.unsaved_tabs.show_bar = true
-- config.plugins.unsaved_tabs.bar_height = 2

local core = require "core"
local config = require "core.config"
local style = require "core.style"
local Node = require "core.node"

config.plugins.unsaved_tabs = config.plugins.unsaved_tabs or {}

local scale = SCALE or 1

local function opt(name, default)
  local v = config.plugins.unsaved_tabs[name]
  if v == nil then return default end
  return v
end

local function get_color()
  return opt("color", { 235, 155, 65, 255 })
end

local function is_dirty(view)
  return view and view.doc and view.doc.is_dirty and view.doc:is_dirty()
end
local raw_draw_tab_title = Node.draw_tab_title
function Node:draw_tab_title(view, font, is_active, is_hovered, x, y, w, h)
  if not (is_dirty(view) and opt("recolor_text", true)) then
    return raw_draw_tab_title(self, view, font, is_active, is_hovered, x, y, w, h)
  end

  local color = get_color()
  local old_dim, old_text = style.dim, style.text
  style.dim = color
  style.text = color

  local ok, err = pcall(raw_draw_tab_title, self, view, font, is_active, is_hovered, x, y, w, h)

  style.dim = old_dim
  style.text = old_text

  if not ok then error(err, 0) end
end

local raw_draw_tab = Node.draw_tab
function Node:draw_tab(view, is_active, is_hovered, is_close_hovered, x, y, w, h, standalone)
  raw_draw_tab(self, view, is_active, is_hovered, is_close_hovered, x, y, w, h, standalone)
  if is_dirty(view) and opt("show_bar", true) then
    local bar_h = math.ceil(opt("bar_height", 2) * scale)
    renderer.draw_rect(x, y + h - bar_h, w, bar_h, get_color())
  end
end
