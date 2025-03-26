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
  ];
  environment.systemPackages = with pkgs; [
    # vesktop
    # (discord.override {
    #   # withOpenASAR = true; ## can do this here too
    #   withVencord = true;
    # })

    ## Wine
    lutris
    winetricks
    protontricks
    wineWowPackages.waylandFull
    # wineWowPackages.stable
    protonup-qt # # Install proton-ge
    gamescope
    mangohud

    ## Games
    prismlauncher
    glfw3-minecraft
    jdk17
    love # for balatro

    ## System
    zed-editor
    nixd # # nix-code interpiter
    nil # # nix lang server
    neofetch
    nvitop
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
    baobab # # disk wiztree.
    obs-studio
    prusa-slicer
  ];

  ###########
  ## Steam ##
  ###########

  programs.steam = {
    enable = true;
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
    # "com.valvesoftware.Steam"
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

  ######################
  ## Remote Managment ##
  ######################

  # services.teamviewer.enable = true; ## Does not stream

  ############
  ## Thunar ##
  ############
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  ## Thunbnails
  services.tumbler.enable = true;

}
