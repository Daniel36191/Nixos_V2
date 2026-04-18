{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
   mod = fun.getMod config __curPos.file;

  config = builtins.readFile ./config.json;
  theme = builtins.readFile ./theme.json;
in
{
  config = lib.mkIf mod.enable {
    programs.hyprpanel = {
      enable = true;
    };
    # home.packages = with pkgs; [
    #   hyprpanel
    # ];
    # home.file.".config/hyprpanel/config.json".text = lib.strings.concatStrings [ config ];
    # home.file.".config/hyprpanel/theme.json".text = lib.strings.concatStrings [ theme ];
  };
}
