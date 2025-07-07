{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [

    ###########
    ## Games ##
    ###########

    ## Wine
    wineWowPackages.waylandFull ## wine for wayland
    # wineWowPackages.stable ## wine
    winetricks
    gamescope
    mangohud
    steamtinkerlaunch


    ###################
    ## CLI sys tools ##
    ###################

    # waypipe
    wayvnc
    neofetch
    wget
    tree
    appimage-run

    ## Alternitives
    eza ## ls
    bat ## cat
    nh ## nixos ...
    # ripgrep ## grep ## not great
    fd ## find
    uutils-coreutils-noprefix ## most coreutils



    ###################
    ## GUI sys tools ##
    ###################

    imv ## Immage viewer
    mpv ## Video viewer

    #################
    ## Dependencys ##
    #################

    ## System
    ffmpeg
    v4l-utils ## Obs virtual cam

    ## File Manager
    unzip
    unrar
    # file-roller ## Only for thunar
    #
    webkitgtk_4_0 ## for orca

  ];
}
