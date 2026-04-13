{
  config,
  lib,
  pkgs,
  unstable,
  personal,
  inputs,
  ...
}:
let
  mod = config.modules.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};

in
{
  config = lib.mkIf mod.enable {
    imports = [
      ./sys-apps.nix
      ./nautilus.nix
    ];
    environment.systemPackages = with pkgs; [
      ###############
      ## User apps ##
      ###############

      pkgs-unstable.librewolf
      # google-chrome

      bitwarden-desktop

      rustdesk-flutter
      kdePackages.kalk
      baobab
      # gnome-disk-utility
      gparted
      mission-center
      # nvitop
      nvtopPackages.nvidia
      lact # # Gpu Overclocking
      ncdu # # wiztree
      # xarchiver ## Archive Manager
      kdePackages.ark # # Archive Manager
      qutebrowser # # For Webapps
      remmina

      ## Discord clients
      # vesktop
      # (discord.override {
      #   withOpenASAR = true;
      #   withVencord = true;
      # })
      equibop

      nixpkgs-personal.teamspeak
      # teamspeak6-client

      telegram-desktop

      sonobus

      ## Matrix Clients
      # nheko
      # cinny-desktop

      teams-for-linux

      waypipe
      xwayland-satellite

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

    ## Run anything: https://github.com/nix-community/comma
    programs.nix-index-database.comma.enable = true;

    ##############
    ## FlatPaks ##
    ##############

    services.flatpak = {
      enable = true;
      update.onActivation = true;
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
    #     thunar-volman ## Mounting Drives
    #     thunar-media-tags-plugin ## More Media Features
    #     thunar-vcs-plugin ## Git Intergration
    #   ];
    # };
    # services.tumbler.enable = true; ## Thunbnails
    # programs.xfconf.enable = true; ## Save Settings
    # services.gvfs.enable = true; ## Mount, trash

    ################
    ## KdeConnect ## (Connect Phone)
    ################
    programs.kdeconnect = {
      enable = true;
    };
  };
}
