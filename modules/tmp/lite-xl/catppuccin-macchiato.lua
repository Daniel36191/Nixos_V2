-- mod-version:3
-- Orginal Author: leofleeo
-- Edited By: Daniel36191
-- Edited to match VSC Macchiato

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#1e1e2e" }
style.background2 = { common.color "#181825" }
style.background3 = { common.color "#363a4f" }
style.text = { common.color "#cad3f5" }
style.caret = { common.color "#f4dbd6" }
style.accent = { common.color "#c6a0f6" }
style.dim = { common.color "#b8c0e0" }
style.divider = { common.color "#c6a0f6" }
style.selection = { common.color "#5b6078" }
style.line_number = { common.color "#6e738d" }
style.line_number2 = { common.color "#c6a0f6" }
style.line_highlight = { common.color "#363a4f" }
style.scrollbar = { common.color "#5b6078" }
style.scrollbar2 = { common.color "#6e738d" }
style.scrollbar_track = { common.color "#1e2030" }

style.syntax["normal"] = { common.color "#eba0ac" }
style.syntax["symbol"] = { common.color "#94e2d5" }
style.syntax["comment"] = { common.color "#9399b2" }
style.syntax["keyword"] = { common.color "#c3a0ec" }
style.syntax["keyword2"] = { common.color "#cdd6f4" }
style.syntax["number"] = { common.color "#fab387" }
style.syntax["literal"] = { common.color "#89b4fa" }
style.syntax["string"] = { common.color "#a6e3a1" }
style.syntax["operator"] = { common.color "#91d7e3" }
style.syntax["function"] = { common.color "#8aadf4" }

style.lint = {
  info = style.syntax["#9399b2"],
  hint = style.syntax["#cdd6f4"],
  warning = style.syntax["#f5a97f"],
  error = { common.color "#ed8796" }
}
