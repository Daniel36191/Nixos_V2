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
    #   # withOpenASAR = true; # can do this here too
    #   withVencord = true;
    # })

    ## Wine
    lutris
    winetricks
    protontricks
    wineWowPackages.waylandFull
    # wineWowPackages.stable
    protonup-qt # Install proton-ge
    gamescope
    mangohud

    ## Games
    prismlauncher
    glfw3-minecraft
    jdk17
    love # for balatro

    ## System
    # zed-editor # vscode replacement missing git gui
    nixd # nix-code interpiter
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
    baobab # disk wiztree.
    obs-studio

    ## Devices
    usb-modeswitch
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


  #############
  ## Devices ##
  #############
  
  # Logitech wheel in pc mode
  services.udev.extraRules = ''
    # Logitech G920 Racing Wheel
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 046d -p c261 -c /etc/usb_modeswitch.d/046d:c261"
  '';
  
  environment.etc."usb_modeswitch.d/046d:c261".text = ''
    # Logitech G920 Racing Wheel
    DefaultVendor=046d
    DefaultProduct=c261
    MessageEndpoint=01
    ResponseEndpoint=01
    TargetClass=0x03
    MessageContent="0f00010142"
  '';
  
  # Adb
  programs.adb.enable = true;
  
  
  ######################
  ## Remote Managment ##
  ######################
  
  # services.teamviewer.enable = true; ## Does not stream


}
