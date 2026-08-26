{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.sys-apps;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [

      ###################
      ## CLI sys tools ##
      ###################

      # waypipe
      wayvnc
      fastfetch
      wget
      appimage-run
      tldr # # breaf man pages
      iotop-c
      sshfs

      ## Alternitives
      eza # ls
      bat # cat
      nh # nixos ...
      uutils-coreutils-noprefix # most coreutils

      ###################
      ## GUI sys tools ##
      ###################

      imv # Immage viewer
      mpv # Video viewer

      #################
      ## Dependencys ##
      #################

      ## System
      ffmpeg
      file

      ## File Manager
      unzip
      unrar
      # file-roller ## Only for thunar

    ];
  };
}
