{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.modules.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};
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
