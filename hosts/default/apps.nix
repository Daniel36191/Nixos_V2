{
  config,
  pkgs,
  host,
  username,
  options,
  inputs,
  lib,
  ...
}:
{
  imports = [
    # ./glfw-wayland.nix
  ];
  environment.systemPackages = with pkgs; [
    # vesktop
    # (discord.override {
    #   # withOpenASAR = true; # can do this here too
    #   withVencord = true;
    # })

    ## Wine
    lutris
    winetricks
    wineWowPackages.waylandFull
    # wineWowPackages.stable
    protonup-qt # Install proton-ge
    gamescope
    mangohud
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
      ];
    })

    ## Games
    prismlauncher
    glfw3-minecraft
    jdk17
    love # for balatro

    ## System
    # zed-editor # vscode replacement missing git gui
    nixd # nix-code interpiter
    neofetch
    micro
    librewolf
    vscode
    cliphist
    wl-clipboard
    pinta
    obsidian
    waypipe
    wayvnc
    blender
    overskride # bluetooth
    baobab # disk wiztree
  ];

  ###########
  ## Steam ##
  ###########

  programs.steam = {
    enable = false;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  ##############
  ## FlatPaks ##
  ##############

  services.flatpak.enable = true;
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
  ];
  services.flatpak.packages = [
    "dev.vencord.Vesktop"
    "com.core447.StreamController"
    "com.github.tchx84.Flatseal"
    "com.valvesoftware.Steam"
    # "org.freedesktop.Platform.VulkanLayer.MangoHud"
  ];

  ####################
  ## Port Forwading ##
  ####################

  networking.firewall = {
    allowedTCPPorts = [
      5900
      25565
    ];
    allowedUDPPorts = [
      5900
      25565
    ];
  };

  # services.tailscale = {
  #   enable = true;
  #   openFirewall = true;
  #   authKeyFile = ./tailscaleauthkey.key;
  #   extraSetFlags = [
  #     "--advertise-exit-node"
  #   ];
  # };

}
