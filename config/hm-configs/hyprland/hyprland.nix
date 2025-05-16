{
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../../variables.nix)
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
        ",../wallpapers/${wallpaper}"
      ];

      wallpapers = [
        ",../wallpapers/${wallpaper}"
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
