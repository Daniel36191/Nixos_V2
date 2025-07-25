{
  lib,
  ...
}:
let
  config = builtins.readFile ./config.jsonc;
  style = builtins.readFile ./style.css;
  flavor = builtins.readFile ./flavor.css;
in
{
  programs.waybar = {
    enable = true;
  };
  home.file.".config/waybar/config".text = lib.strings.concatStrings [ config ];
  home.file.".config/waybar/style.css".text = lib.strings.concatStrings [ style ];
  home.file.".config/waybar/flavor.css".text = lib.strings.concatStrings [ flavor ];
}
