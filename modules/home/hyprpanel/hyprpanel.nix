{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.hyprpanel;

  config = builtins.readFile ./config.json;
  theme = builtins.readFile ./theme.json;
in
{
  config = lib.mkIf mod.enable {
    programs.hyprpanel = {
      enable = true;
    };
    # home.file.".config/hyprpanel/config.json".text = lib.strings.concatStrings [ config ];
    # home.file.".config/hyprpanel/theme.json".text = lib.strings.concatStrings [ theme ];
  };
}
