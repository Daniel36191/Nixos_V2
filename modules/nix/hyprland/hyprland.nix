{
  config,
  lib,
  pkgs,
  inputs,
  var,
  ...
}:
let
  mod = config.mod.hyprland;

  command = "${
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
  }/bin/start-hyprland";

  cage-kitty = pkgs.writeShellScriptBin "cage-kitty" ''
    exec ${pkgs.cage}/bin/cage -s -- ${pkgs.kitty}/bin/kitty
  '';

  cage-kitty-session =
    (pkgs.writeTextDir "share/wayland-sessions/cage-kitty.desktop" ''
      [Desktop Entry]
      Name=Cage + Kitty
      Comment=Kitty terminal in a minimal Cage compositor
      Exec=${cage-kitty}/bin/cage-kitty
      Type=Application
    '').overrideAttrs
      (_: {
        passthru.providedSessions = [ "cage-kitty" ];
      });
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [
      tuigreet
      hyprpicker
      hyprpaper
      hyprsunset

      libnotify
      playerctl # Media keys
      jq # For volume script
      imagemagick # For boox script

      ## Clipboard
      grimblast
      slurp
      wl-clipboard
      cliphist

      cage-kitty

    ];

    ## Portals
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
        xdg-desktop-portal
      ];
    };

    ## Login Manager
    services.displayManager.sessionPackages = [ cage-kitty-session ];
    services = {
      greetd = {
        enable = true;
        useTextGreeter = true; # For Tui Greet
        settings = {
          default_session = {
            user = var.username;
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${command}";
          };
          # initial_session = {
          #   command = "${command}";
          #   user = var.username;
          # };
        };
      };
    };

    ## Keyring
    services.gnome.gnome-keyring.enable = true;
    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };
    environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

    ## Hyprland Cachix
    nix = {
      settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
    };
  };
}
