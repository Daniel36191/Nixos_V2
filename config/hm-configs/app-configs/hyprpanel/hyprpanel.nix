{
  pkgs,
  lib,
  ...
}:
let
  config = builtins.readFile ./config.json;
  theme = builtins.readFile ./theme.json;
in
{
  programs.hyprpanel = {
    enable = false;
  };
  home.packages = with pkgs; [
    hyprpanel
  ];
	home.file.".config/hyprpanel/config.json".text = lib.strings.concatStrings [ config ];
	home.file.".config/hyprpanel/theme.json".text = lib.strings.concatStrings [ theme ];
}