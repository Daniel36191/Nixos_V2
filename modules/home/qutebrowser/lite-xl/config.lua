-- mod-version:3
-- Orginal Author: Daniel36191

local config = require "core.config"

-- Dissable scroll
config.plugins.scale.use_mousewheel = false

-- Ignore .lock files
table.insert(config.ignore_files, "*.lock")

config.fps = 120

config.animate_drag_scroll = true

config.plugins.bracketmatch.style = "frame"

config.plugins.lineguide.enabled = true

config.plugins.terminal.shell = "lazygit"
