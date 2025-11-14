{
  inputs,
  ...
}:
{
  imports = [
    ../hm-main.nix
    ../hm-configs/desktop-files.nix
    ../hm-configs/theme.nix
    ../hm-configs/hyprland/hyprland.nix
    ../hm-configs/hyprland/wlogout.nix
    # ../hm-configs/hyprland/hyprlock.nix

    ../hm-configs/app-configs/fastfetch/fastfetch.nix
    ../hm-configs/app-configs/rofi/rofi.nix
    ../hm-configs/app-configs/rofi/config-emoji.nix
    ../hm-configs/app-configs/rofi/config-long.nix
    # ../hm-configs/app-configs/swaync.nix
    # ../hm-configs/app-configs/waybar.nix # #old waybar
    # ../hm-configs/app-configs/waybar/waybar.nix
    # ../hm-configs/app-configs/quickshell.nix
    # ../hm-configs/app-configs/hyprpanel/hyprpanel.nix
    inputs.dms.homeModules.dankMaterialShell.default
    ../hm-configs/app-configs/dankshell.nix
    
    ../hm-configs/app-configs/btop.nix
    ../hm-configs/app-configs/swappy.nix
    ../hm-configs/app-configs/github.nix
    ../hm-configs/app-configs/kitty.nix

  ];
}
