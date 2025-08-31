{
  pkgs,
  ...
}:
let
  inherit (import ./variables.nix)
    username
    ;
in
{
  imports = [
    ./hm-configs/desktop-files.nix
    ./hm-configs/theme.nix
    ./hm-configs/hyprland/hyprland.nix
    ./hm-configs/hyprland/wlogout.nix
    # ./hm-configs/hyprland/hyprlock.nix

    ./hm-configs/app-configs/fastfetch/fastfetch.nix
    ./hm-configs/app-configs/rofi/rofi.nix
    ./hm-configs/app-configs/rofi/config-emoji.nix
    ./hm-configs/app-configs/rofi/config-long.nix
    # ./hm-configs/app-configs/swaync.nix
    # ./hm-configs/app-configs/waybar.nix # #old waybar
    # ./hm-configs/app-configs/waybar/waybar.nix
    # ./hm-configs/app-configs/quickshell.nix
    ./hm-configs/app-configs/hyprpanel/hyprpanel.nix
    ./hm-configs/app-configs/btop.nix
    ./hm-configs/app-configs/swappy.nix
    ./hm-configs/app-configs/github.nix
    ./hm-configs/app-configs/kitty.nix

  ];

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
