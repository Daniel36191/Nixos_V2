{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.rofi.config-long;
in
{
  config = lib.mkIf mod.enable {
    home.file.".config/rofi/config-long.rasi".text = ''
      @import "~/.config/rofi/config.rasi"
      window {
        width: 50%;
      }
      entry {
        placeholder: "🔎 Search       ";
      }
      listview {
        columns: 1;
        lines: 8;
        scrollbar: true;
      }
    '';
  };
}
