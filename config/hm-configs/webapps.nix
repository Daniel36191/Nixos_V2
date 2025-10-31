{ pkgs, lib, ... }:

let
  desktopConfig = [
    { name = "Soundcloud"; domain = "soundcloud.com"; icon = "soundcloud"; terminal = false; categories = [ "Audio" "Music" ]; }
  ];

  # Function to download icon with fake hash
  mkIcon = iconName: pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/41cfe644047fc3a4c49c22acc721cacc3e1021fe/svgs/brands/${iconName}.svg";
    hash = 
      if iconName == "soundcloud" then "sha256-1c8s8v8p1z1w8q8y8r8x8s8z8a8q8w8e8r8t8y8u8i8o8p8a8s8d8f8"
      else if iconName == "Example" then "sha256-2d9t9w9q2e9r9t9y9u9i9o9p9a9s9d9f9g9h9j9k9l9z9x9c9v9"
      else lib.fakeSha256;
  };

  # Function to create icon directory structure
  mkIconDir = iconName: pkgs.runCommand "${iconName}-icon" {} ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${mkIcon iconName} $out/share/icons/hicolor/256x256/apps/${iconName}.png
  '';

  # Function to create desktop entry configuration
  mkDesktopEntry = cfg: {
    name = cfg.name;
    icon = "${mkIconDir cfg.icon}/share/icons/hicolor/256x256/apps/${cfg.icon}.png";
    exec = "${pkgs.qutebrowser} https://${cfg.domain}";
    terminal = cfg.terminal or false;
    categories = cfg.categories;
    type = "Application";
  };

  # Create all desktop entries
  desktopEntries = builtins.listToAttrs (map (cfg: {
    name = cfg.name;
    value = mkDesktopEntry cfg;
  }) desktopConfig);

  # Create shell aliases
  shellAliases = builtins.listToAttrs (map (cfg: {
    name = lib.toLower cfg.name;
    value = "${pkgs.qutebrowser} https://${cfg.domain}";
  }) desktopConfig);

in
{
  xdg.desktopEntries = desktopEntries;
  environment.shellAliases = shellAliases;
}