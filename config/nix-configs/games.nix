{
    pkgs,
    pkgs-stable,
    username,
    inputs,
    ...
}:
let
    glfw-minecraft-wayland = pkgs.callPackage ../../custom-apps/glfw-minecraft-wayland/package.nix { };
    # proton-vkvr = pkgs.callPackage ../../custom-apps/proton-vkvr.nix { };
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
    wine64
    winetricks
    gamescope
    mangohud
    steamtinkerlaunch
    umu-launcher
    

    ## Lossless Scaling on linux (only for vulkan)
    # lsfg-vk
    # lsfg-vk-ui

    ## Modding
    r2modman
    pkgs-stable.gale ## R2 but better
    bs-manager ## Beatsaber Modding
    satisfactorymodmanager
    ckan ## KSP
    beammp-launcher

    ## Games
    techmino ## tetris

    ## Tracking
    # aitrack
    # slimevr
    ];

    ##############
    ## FlatPaks ##
    ##############

    services.flatpak = {
      packages = [
        "org.vinegarhq.Sober" ## roblox
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
    extest.enable = true; ## For wayland and controlers
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = false;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true; ## Defaults mangohud on for every game
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
      inputs.lemonake.packages.${pkgs.system}.proton-ge-rtsp ## for VRC
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

  ################
  ## Game Fixes ##
  ################
  system.activationScripts.vrcpics = let 
    vrc-pics-path = "/home/${username}/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat/";
  in ''
    if [[ -d ${vrc-pics-path} ]]; then
      ln -sf ${vrc-pics-path} /home/${username}/Pictures  
    fi
    
  '';
}
