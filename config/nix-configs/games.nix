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

    ## Games
    techmino ## tetris

    ## Track IR
    # aitrack
    ];

    ##############
    ## FlatPaks ##
    ##############

    services.flatpak = {
      packages = [
        "org.vinegarhq.Sober" ## roblox
      ];
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
