{
  config,
  lib,
  pkgs,
  inputs,
  unstable,
  pkgs-personal,
  var,
  ...
}:
let
  mod = config.mod.games;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with unstable; [
      ## Minecraft
      prismlauncher
      # glfw3-minecraft
      pkgs-personal.glfw-minecraft-wayland

      ## Runners
      lutris
      jdk17

      ## Utils
      mangohud
      gamescope

      ## Wine
      unstable.wineWow64Packages.unstableFull
      # wineWow64Packages.stable
      unstable.wine64
      unstable.winetricks
      steamtinkerlaunch
      umu-launcher

      ## Lossless Scaling on linux (only for vulkan)
      # lsfg-vk
      # lsfg-vk-ui

      ## Modding
      r2modman
      gale
      bs-manager
      satisfactorymodmanager
      ckan
      beammp-launcher

      ## Games
      techmino

      ## Tracking
      # aitrack
      # slimevr
    ];

    ##############
    ## FlatPaks ##
    ##############

    services.flatpak = {
      packages = [
        "org.vinegarhq.Sober" # roblox
      ];
    };

    ###########
    ## Steam ##
    ###########
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extest.enable = true; # For wayland and controlers
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = false;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true; # Defaults mangohud on for every game
          OBS_VKCAPTURE = true;
          RADV_TEX_ANISO = 16;
        };
        extraLibraries =
          p: with p; [
            atk
          ];
      };
      extraPackages = with unstable; [
        gamescope
        mangohud
        gamemode
      ];
      extraCompatPackages = with unstable; [
        proton-ge-bin
        inputs.lemonake.packages.${pkgs.stdenv.hostPlatform.system}.proton-ge-rtsp # for VRC
        steamtinkerlaunch
        # pkgs-personal.proton-vkvr
      ];
    };
    boot = {
      ## Needed For Some Steam Games
      kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
      };
    };

    ################
    ## Game Fixes ##
    ################
    system.activationScripts.vrcpics =
      let
        vrc-pics-path = "/home/${var.username}/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat/";
      in
      ''
        if [[ -d ${vrc-pics-path} ]]; then
          ln -sf ${vrc-pics-path} /home/${var.username}/Pictures
        fi

      '';
  };
}
