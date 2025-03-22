{
  lib,
  username,
  host,
  config,
  ...
}:

let
  inherit (import ../../nix-configs/variables.nix)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout
    wallpaper
    ;
in
with lib;
{
  ## Wallpaper
   services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      preload = [
        (builtins.toString wallpaper)
      ];

      wallpapers = [
        ",${builtins.toString wallpaper}"
      ];
    };
  };

  ## Hyprland Conf
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = 
      let
        hyprlandconf = builtins.readFile ./hyprland.conf;
      in
      concatStrings [
        hyprlandconf
      ];

  };
}
