{
  lib,
  pkgs,
  inputs,
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
    plugins = [
      # pkgs.hyprlandPlugins.hycov ## alt tab like function ## Broken in Nixpkgs
      inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
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
