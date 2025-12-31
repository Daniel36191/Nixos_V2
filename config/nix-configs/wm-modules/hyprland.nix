{
  pkgs,
  username,
  inputs,
  ...
}:
let
  command = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/bin/start-hyprland";
in
{
  environment.systemPackages = with pkgs; [
    tuigreet
    hyprpicker
    hyprpaper
    hyprsunset ## Orange Wash Screen

    libnotify
    playerctl ## Media keys
    jq ## For volume script

    ## Clipboard
    grimblast
    slurp
    wl-clipboard
    cliphist

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
  services = {
    greetd = {
      enable = true;
      useTextGreeter = true; ## For Tui Greet
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${command}";
        };
        initial_session = {
          command = "${command}";
          user = username;
        };
      };
    };
  };

  ## Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true; ## unlocks keyring
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID"; ## set the runtime directory fixes keyring unlock

  ## Hyprland Cachix
  nix = {
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };

}
