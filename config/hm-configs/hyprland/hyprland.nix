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

  ## Volume script for config
  home.file.".config/hypr/scripts/volume.sh" = {
    text = let
    volume-sh = builtins.readFile ./volume.sh;
  in lib.strings.concatStrings [ volume-sh ];
  executable = true;
  };
  
  home.file.".config/hypr/scripts/boox.sh" = {
    text = let
    boox-sh = builtins.readFile ./boox.sh;
  in lib.strings.concatStrings [ boox-sh ];
  executable = true;
  };

  home.file.".config/hypr/scripts/boox.png" = {
    source = ./boox.png;
    force = true;
  };
}
