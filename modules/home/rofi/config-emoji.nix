{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.rofi.config-emoji;
in
{
  config = lib.mkIf mod.enable {
    home.file.".config/rofi/config-emoji.rasi".text = ''
      @import "~/.config/rofi/config-long.rasi"
      entry {
        width: 45%;
        placeholder: "🔎 Search Emoji's 👀";
      }
    '';
  };
}
