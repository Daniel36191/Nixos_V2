{
  pkgs,
  ...
}:
let
  desktopConfig = [
    { name = "Soundcloud"; domain = "soundcloud.com"; categories = [ "Audio" "Music" ]; }
    { name = "Google-Home"; domain = "home.google.com"; categories = [ "Application" ]; }
  ];

  ## Function to create desktop entry configuration
  mkDesktopEntry = cfg: {
    name = cfg.name;
    exec = "${pkgs.qutebrowser}/bin/qutebrowser https://${cfg.domain}";
    terminal = cfg.terminal or false;
    categories = cfg.categories;
    type = "Application";
  };

  ## Create all desktop entries
  desktopEntries = builtins.listToAttrs (map (cfg: {
    name = cfg.name;
    value = mkDesktopEntry cfg;
  }) desktopConfig);

in
{
  xdg.desktopEntries = desktopEntries;
}