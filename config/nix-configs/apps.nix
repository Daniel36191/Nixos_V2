{
  pkgs,
  inputs,
  pkgs-stable,
  ...
}:
let
in
{
  imports = [
    ./sys-apps.nix
  ];
  environment.systemPackages = with pkgs; [
    ###############
    ## User apps ##
    ###############

    librewolf
    rustdesk-flutter
    nautilus # # File man
    gnome-calculator
    baobab # # Disk usage analyzer
    # gnome-disk-utility
    gparted
    mission-center # # Task manager
    nvitop # # btop for gpu
    lact # # Gpu Overclocking
    ncdu # # wiztree
    xarchiver
    qutebrowser ## For Webapps

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

  ];
  nixpkgs.config = {
    # cudaSupport = true;
    # cudnnSupport = true;
    permittedInsecurePackages = [
      # "olm-3.2.16" # # For matrix clients
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
      "com.github.tchx84.Flatseal"
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
  # environment.variables = {
  #     GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules"; ## Fixes Network tab not working
  # };
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



  ################
  ## KdeConnect ## (Connect Phone)
  ################
  programs.kdeconnect = {
    enable = true;
  };

}
