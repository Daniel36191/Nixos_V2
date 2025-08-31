{
  lib,
  pkgs,
  inputs,
  nix-host,
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
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      # pkgs.hyprlandPlugins.hycov ## alt tab like function ## Broken in Nixpkgs
      inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
    ];
    extraConfig =
      let
        hyprland-main = builtins.readFile ./hyprland-main.conf;
        hyprland-monitors = if nix-host == "pc"
          then
             builtins.readFile ./hyprland-pc.conf;
          else
            builtins.readFile ./hyprland-laptop.conf;
      in
      concatStrings [
        hyprland-main
      ];

  };
}
