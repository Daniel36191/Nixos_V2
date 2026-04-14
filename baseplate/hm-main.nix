{
  config,
  lib,
  host,
  ...
}:
let
  importsModules =
    dir:
    lib.filter (f: builtins.match ".*\\.nix" (baseNameOf (toString f)) != null) (
      lib.filesystem.listFilesRecursive dir
    );
in
{
  ## Import Modules
  imports = (importsModules ../modules/home) ++ [
    ../hosts/${host}/${host}-hm-main.nix
  ];

  home.username = "${config.mod.username}";
  home.homeDirectory = "/home/${config.mod.username}";
  home.stateVersion = "25.05";

  home.packages = [
  ];

  ## Wallpapers
  home.file."Pictures/Wallpapers" = {
    source = ../extra-files/wallpapers;
    recursive = true;
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  programs = {
    home-manager.enable = true;
  };
}
