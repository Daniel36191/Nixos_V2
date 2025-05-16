{
  pkgs,
  ...
}:{

  environment.systemPackages = with pkgs; [

    ## Cli
    wget
    killall
    git
    ncdu ## wiztree
    ## Alternitives
    eza ## ls
    bat ## cat
    nh ## better nixos ...

    ## Core system utils
    unzip
    unrar
    lxqt.lxqt-policykit
    libnotify
    v4l-utils ## obs virtual cam
    ffmpeg


    pkg-config
    appimage-run
    nixfmt-rfc-style
    file-roller
    swaynotificationcenter
    imv
    mpv
    pavucontrol
    tree

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
