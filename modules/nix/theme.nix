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
    ############
    ## Stylix ##
    ############

    stylix = {
      enable = true;
      image = ../hm-configs/wallpapers/${config.mod.wallpaper};
      base16Scheme = {
        base00 = "24273a"; # base
        base01 = "1e2030"; # mantle
        base02 = "363a4f"; # surface0
        base03 = "494d64"; # surface1
        base04 = "5b6078"; # surface2
        base05 = "cad3f5"; # text
        base06 = "f4dbd6"; # rosewater
        base07 = "b7bdf8"; # lavender
        base08 = "ed8796"; # red
        base09 = "f5a97f"; # peach
        base0A = "eed49f"; # yellow
        base0B = "a6da95"; # green
        base0C = "8bd5ca"; # teal
        base0D = "8aadf4"; # blue
        base0E = "c6a0f6"; # mauve
        base0F = "f0c6c6"; # flamingo
      };
      polarity = "dark";
      opacity.terminal = 1.0;
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
        monospace = {
          package = pkgs.redhat-nerd;
          name = "RedHatMonoNerdFont-Regular";
        };
        sansSerif = {
          package = pkgs.redhat-nerd;
          name = "RedHatNerdFont-TextRegular";
        };
        serif = {
          package = pkgs.redhat-nerd;
          name = "RedHatNerdFont-TextRegular";
        };
        sizes = {
          applications = 12;
          terminal = 15;
          desktop = 11;
          popups = 12;
        };
      };
    };

    ###########
    ## Fonts ##
    ###########

    fonts = {
      packages = with pkgs; [
        miracode
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
        font-awesome
        symbola
        material-icons
      ];
    };
  };
}
