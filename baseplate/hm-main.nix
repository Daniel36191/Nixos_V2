{
  config,
  ...
}:
{
  home.username = "${config.usrConfig.username}";
  home.homeDirectory = "/home/${config.usrConfig.username}";
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