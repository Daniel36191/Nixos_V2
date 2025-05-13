{
  pkgs,
  ...
}:{
  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";

  environment.systemPackages = with pkgs; [
    wget
    killall
    docker-compose
    eza
    git
    htop
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    v4l-utils
    ncdu
    pciutils
    ffmpeg
    bat
    pkg-config
    brightnessctl
    swappy
    appimage-run
    networkmanagerapplet
    yad
    playerctl
    nh
    nixfmt-rfc-style
    file-roller
    swaynotificationcenter
    imv
    mpv
    pavucontrol
    tree

  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
