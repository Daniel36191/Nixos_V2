{
  lib,
  username,
  host,
  config,
  pkgs,
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
    plugins = with pkgs.hyprlandPlugins; [
      # hycov ## alt tab like funftion ## Broken in Nixpkgs
    ];
    extraConfig =
      let
        hyprlandconf = builtins.readFile ./hyprland.conf;
      in
      concatStrings [
        hyprlandconf
      ];

  };
}
