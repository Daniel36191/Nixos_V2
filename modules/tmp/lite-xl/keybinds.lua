-- mod-version:3
-- Orginal Author: Daniel36191
-- https://lite-xl.com/user-guide/keymap/

local keymap = require "core.keymap"

-- Open command palette
keymap.unbind("ctrl+shift+p", "core:find-command")
keymap.unbind("ctrl+shift+p", "pallate:toggle")
keymap.add { ["f1"] = "core:find-command" }

-- Alt move lines
keymap.unbind("ctrl+up", "doc:move-lines-up")
keymap.unbind("ctrl+down", "doc:move-lines-down")
keymap.add {
  ["alt+up"] = "doc:move-lines-up",
  ["alt+down"] = "doc:move-lines-down",
}

-- Multicursor
keymap.unbind("ctrl+shift+up", "doc:create-cursor-previous-line")
keymap.unbind("ctrl+shift+down", "doc:create-cursor-next-line")
keymap.unbind("ctrl+1lclick", "doc:split-cursor")
keymap.add {
  ["alt+shift+up"] = "doc:create-cursor-previous-line",
  ["alt+shift+down"] = "doc:create-cursor-next-line",
  ["alt+1lclick"] = "doc:split-cursor",
}

-- Autocomplete
keymap.unbind("tab", "autocomplete:complete")
keymap.add {
  ["tab"] = "autocomplete:tab-cycle-complete",
}

-- Rename in treeview
keymap.add {
  ["f2"] = "treeview:rename"
}

-- Open project
keymap.add {
  ["ctrl+shift+o"] = "core:open-project-folder",
}

-- New Doc
keymap.unbind("ctrl+n", "core:new-doc")
keymap.add {
  ["ctrl+t"] = "core:new-doc",
}

-- Logs
keymap.add {
  ["ctrl+shift+l"] = "log:open-as-doc"
}
