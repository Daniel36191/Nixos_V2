{
  lib,
  pkgs,
  inputs,
  nix-host,
  wallpaper,
  ...
}:
{
  ## Wallpaper
  # services.hyprpaper = {
  #   enable = true;
  #   settings = {
  #     ipc = "off";
  #     splash = false;
  #     preload = [
  #       ",../wallpapers/${wallpaper}"
  #     ];
  # 
  #     wallpapers = [
  #       ",../wallpapers/${wallpaper}"
  #     ];
  #   };
  # };

  ## Hyprland Conf
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
    ]
    # ++ (lib.optionals (nix-host == "pc") [ inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit ])
    ;
    extraConfig =
      let
        hyprland-main = builtins.readFile ./hyprland-main.conf;
        hyprland-machine = if nix-host == "pc"
          then
             builtins.readFile ./hyprland-pc.conf
          else
            builtins.readFile ./hyprland-laptop.conf;
      in
      lib.strings.concatStrings [
        hyprland-main
        hyprland-machine
      ];
  };

  home.file.".config/hypr/scripts" = {
    source = ./scripts;
    force = true;
    executable = true;
    recursive = true;
  };
  home.file.".config/hypr/icons" = {
    source = ./icons;
    force = true;
    recursive = true;
  };
}
