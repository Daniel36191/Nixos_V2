{
    inputs,
    pkgs,
    username,
    ...
}:
{
  ## Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  ## Scripts
  home.packages = [
    (import ../scripts/task-waybar.nix { inherit pkgs; })
    (import ../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../scripts/web-search.nix { inherit pkgs; })
    (import ../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../scripts/screenshootin.nix { inherit pkgs; })
  ];

  ## Wallpapers
  home.file."Pictures/Wallpapers" = {
    source = ./hm-configs/wallpapers;
    recursive = true;
  };

  ## Create XDG Dirs (Pictures, Desktop, Docs, etc)
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