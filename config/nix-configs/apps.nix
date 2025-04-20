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
    #   withOpenASAR = true; ## can do this here too
    #   withVencord = true;
    # })
    equibop ## this works??


    ## Wine
    lutris
    wineWowPackages.waylandFull
    # wineWowPackages.stable
    # protonup-qt # # Install proton-ge
    gamescope
    mangohud

    ## Games
    prismlauncher
    glfw3-minecraft
    jdk17
    love # for balatro
    slimevr ## slime vr :)

    ## System
    # gimp
    lazygit
    # vscode
    zed-editor
    nixd ## nix-code interpiter
    nil ## nix lang server
    neofetch
    nvitop
    micro
    librewolf
    cliphist
    wl-clipboard
    # pinta
    obsidian
    waypipe
    wayvnc
    baobab ## disk wiztree.
    obs-studio
    # prusa-slicer ## segmentation fault core dumped, error no idea installed flatpak
    gnome-disk-utility ## for editing disks
    nautilus

    inputs.blender-cuda.packages.${pkgs.system}.default
  ];
  nixpkgs.config = {
    allowUnfree = true;
    # cudaSupport = true;
    # cudnnSupport = true;
  };


  ##############
  ## FlatPaks ##
  ##############

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      # "dev.vencord.Vesktop"
      "com.core447.StreamController"
      "com.github.tchx84.Flatseal"
      "com.tdameritrade.ThinkOrSwim"
      "org.gimp.GIMP"
      "io.github.nate_xyz.Paleta"
      "com.prusa3d.PrusaSlicer"
      "org.vinegarhq.Sober"
    ];
  };


  ###########
  ## Steam ##
  ###########

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
    extest.enable = true; ## For wayland
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = false;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
        OBS_VKCAPTURE = true;
        RADV_TEX_ANISO = 16;
      };
      extraLibraries = p: with p; [
        atk
      ];
    };
    extraPackages = with pkgs; [
      gamescope
      mangohud
      # glibc_multi
      # (pkgs.glibc.overrideAttrs (old: {
      #           version = "2.35";
      #           src = pkgs.fetchurl {
      #             url = "mirror://gnu/glibc/glibc-2.35.tar.gz";
      #             sha256 = "sha256-Po4MYZXajfvTHXfFb7jZlXb7hV+v1HqeColeUf1ZQtQ="; # Update with actual hash
      #           };
      #         }))
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      proton-ge-rtsp-bin
    ];
  };
  hardware.steam-hardware.enable = true;



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
  ## Thunar ## File Man
  ############
  # programs.thunar = {
  #   enable = true;
  #   plugins = with pkgs.xfce; [
  #     thunar-archive-plugin
  #     thunar-volman
  #   ];
  # };
  # ## Thunbnails
  # services.tumbler.enable = true;


  ##############
  ## Nautilus ## File Man
  ##############
  services = {
    gnome.sushi.enable = true;
    gvfs.enable = true;
  };
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };
  nixpkgs.overlays = [
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    })
  ];





  #################
  ## Thunderbird ## (E-Mail)
  #################
  programs.thunderbird = {
    enable = true;
  };

}
