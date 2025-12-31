{
  pkgs,
  inputs,
  pkgs-stable,
  ...
}:
let
  teamspeak-custom = pkgs.callPackage ../../custom-apps/teamspeak.nix { };
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
    # google-chrome

    bitwarden-desktop
    
    rustdesk-flutter
    kdePackages.kalk ## Calculator
    baobab ## Disk usage analyzer
    # gnome-disk-utility
    gparted
    mission-center ## Task manager
    # nvitop ## btop for gpu
    nvtopPackages.nvidia
    lact ## Gpu Overclocking
    ncdu ## wiztree
    # xarchiver ## Archive Manager
    kdePackages.ark ## Archive Manager
    qutebrowser ## For Webapps

    ## Discord clients
    # vesktop
    # (discord.override {
    #   withOpenASAR = true;
    #   withVencord = true;
    # })
    equibop

    teamspeak-custom

    sonobus

    ## Matrix Clients
    # nheko
    # cinny-desktop


    ## KDE Dolphin
    # # kdePackages.dolphin
    # kdePackages.qtsvg
    # kdePackages.kio-fuse #to mount remote filesystems via FUSE
    # kdePackages.kio-extras #extra protocols support (sftp, fish and more)
    # ## Previews Check Arch Wiki for this: https://wiki.archlinux.org/title/Dolphin#File_previews
    # kdePackages.kdegraphics-thumbnailers ## Pics, PDF, & Blender??
    # kdePackages.ffmpegthumbs ## videos
    # icoutils ## ico
    # kdePackages.kdesdk-thumbnailers ## Extentions
    # kdePackages.kimageformats ## Gimp
    # kdePackages.qtimageformats ## Other Pics
    # resvg ## Svgs
    # kdePackages.taglib ## Audio
    # (kdePackages.dolphin.overrideAttrs (oldAttrs: {
    # nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ makeWrapper ];
    # postInstall = (oldAttrs.postInstall or "") + ''
    #   wrapProgram $out/bin/dolphin \
    #       --set XDG_CONFIG_DIRS "${libsForQt5.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
    #       --run "${kdePackages.kservice}/bin/kbuildsycoca6 --noincremental ${libsForQt5.kservice}/etc/xdg/menus/applications.menu"
    # '';
    # }))



  ];
  nixpkgs.config = {
    # cudaSupport = true;
    # cudnnSupport = true;
    permittedInsecurePackages = [
      # "olm-3.2.16" ## For matrix clients
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

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman ## Mounting Drives
      thunar-media-tags-plugin ## More Media Features
      thunar-vcs-plugin ## Git Intergration
    ];
  };
  services.tumbler.enable = true; ## Thunbnails
  programs.xfconf.enable = true; ## Save Settings
  # services.gvfs.enable = true; ## Mount, trash


  ##############
  ## Nautilus ## File Man
  ##############

  # services = {
  #   gnome.sushi.enable = true;
  #   gvfs.enable = true;
  # };
  # programs.nautilus-open-any-terminal = {
  #   enable = true;
  #   terminal = "kitty";
  # };
  # # environment.variables = {
  # #     GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules"; ## Fixes Network tab not working
  # # };
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     nautilus = prev.nautilus.overrideAttrs (nprev: {
  #       buildInputs =
  #         nprev.buildInputs
  #         ++ (with pkgs.gst_all_1; [
  #           gst-plugins-good
  #           gst-plugins-bad
  #         ]);
  #     });
  #   })
  # ];



  ################
  ## KdeConnect ## (Connect Phone)
  ################
  programs.kdeconnect = {
    enable = true;
  };

}
