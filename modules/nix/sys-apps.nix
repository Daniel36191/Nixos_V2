{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.modules.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [

      ###################
      ## CLI sys tools ##
      ###################

      # waypipe
      wayvnc
      neofetch
      wget
      appimage-run

      ## Alternitives
      eza # # ls
      bat # # cat
      nh # # nixos ...
      uutils-coreutils-noprefix # # most coreutils

      ###################
      ## GUI sys tools ##
      ###################

      imv # # Immage viewer
      mpv # # Video viewer

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
