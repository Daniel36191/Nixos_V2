{
    pkgs,
    inputs,
    ...
}:
let
    glfw-minecraft-wayland = pkgs.callPackage ../../custom-apps/glfw-minecraft-wayland/package.nix { };
    proton-vkvr = pkgs.callPackage ../../custom-apps/proton-vkvr.nix { };
in
{
    environment.systemPackages = with pkgs; [
    ## Minecraft
    prismlauncher
    # glfw3-minecraft
    glfw-minecraft-wayland

    ## Runners
    lutris
    jdk17
    ## Wine
    wineWowPackages.waylandFull ## wine for wayland
    # wineWowPackages.stable ## wine
    winetricks
    gamescope
    mangohud
    steamtinkerlaunch

    ## Modding
    r2modman
    gale ## R2 but better
    # bs-manager ## Beatsaber Modding

    ## Games
    techmino # # tetris

    ## Track IR
    # aitrack
    ];

    ##############
    ## FlatPaks ##
    ##############

    services.flatpak = {
      packages = [
        "org.vinegarhq.Sober" # # roblox
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
    extest.enable = true; # # For wayland
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = false;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
        OBS_VKCAPTURE = true;
        RADV_TEX_ANISO = 16;
      };
      extraLibraries =
        p: with p; [
          atk
        ];
    };
    extraPackages = with pkgs; [
      gamescope
      mangohud
      gamemode
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      proton-ge-rtsp-bin
      steamtinkerlaunch
      # proton-vkvr
    ];
  };
   boot = {
    ## Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
   };
}