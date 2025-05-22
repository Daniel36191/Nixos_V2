{
  pkgs,
  ...
}:
{
  imports = [
    ./sys-apps.nix
  ];
  environment.systemPackages = with pkgs; [

    ###############
    ## User apps ##
    ###############

    librewolf
    obsidian ## Notes
    obs-studio
    # inputs.blender-cuda.packages.${pkgs.system}.default
    # gimp ## Image editing
    pinta ## Image editing
    # prusa-slicer ## Segmentation fault core dumped, error

    ## System apps
    nautilus ## File man
    baobab ## Disk usage analyzer
    gnome-disk-utility ## Disk manager
    mission-center ## Task manager
    nvitop ## btop for gpu
    ncdu ## wiztree

    ## Discord clients
    # vesktop
    # (discord.override {
    #   withOpenASAR = true; ## can do this here too
    #   withVencord = true;
    # })
    equibop

    ## Matrix Clients
    # nheko
    # cinny-desktop

    ## Games
    prismlauncher
    glfw3-minecraft
    jdk17
    slimevr ## slime vr :)
    # bs-manager ## Beatsaber Modding
    lutris

    ############
    ## Coding ##
    ############

    ## Git tools
    lazygit
    git
    github-desktop

    ## Code editors
    # vscode
    zed-editor
    micro

    ## Language servers
    nixd ## Nix-lang interpiter
    nil ## Nix-lang server
    nixfmt-rfc-style ## Nix-lang formattor

  ];
  nixpkgs.config = {
    # cudaSupport = true;
    # cudnnSupport = true;
    permittedInsecurePackages = [
      "olm-3.2.16" ## For matrix clients
    ];
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

  hardware.steam-hardware.enable = true;
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
      gamemode
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      proton-ge-rtsp-bin
      luxtorpeda
      steamtinkerlaunch
      # (callPackage ../../custom-apps/proton-vkvr.nix {})
    ];
  };


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


  ################
  ## KdeConnect ## (Connect Phone)
  ################
  programs.kdeconnect = {
    enable = true;
  };
}
