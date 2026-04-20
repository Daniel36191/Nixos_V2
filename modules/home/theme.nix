{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.home.theme;

  folders-catppuccin = pkgs.catppuccin-papirus-folders.override {
    flavor = "macchiato";
    accent = "blue";
  };
in
{
  config = lib.mkIf mod.enable {
    home.packages = with pkgs; [
      papirus-folders
      folders-catppuccin
    ];

    stylix.targets = {
      waybar.enable = false;
      rofi.enable = false;
      hyprland.enable = false;
    };

    gtk = {
      iconTheme = {
        name = "Papirus-Dark";
        package = folders-catppuccin;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    qt = {
      enable = true;
      style.name = lib.mkDefault "adwaita-dark";
      platformTheme.name = lib.mkDefault "kde6";
    };
  };
}
