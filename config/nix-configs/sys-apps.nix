{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [

    ###################
    ## CLI sys tools ##
    ###################

    # waypipe
    wayvnc
    neofetch
    wget
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
    
    ## File Manager
    unzip
    unrar
    # file-roller ## Only for thunar

    ## Apps
    webkitgtk_4_0 ## for orca

  ];
}
