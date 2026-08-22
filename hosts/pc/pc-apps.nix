{
  pkgs,
  pkgs-unstable,
  pkgs-personal,
  ...
}:
let
in
{
  environment.systemPackages = with pkgs; [
    streamcontroller
    pkgs-personal.lulzbot-cura
    # lan-mouse ## Software KVM
    songrec
    pkgs-unstable.razer-cli
    pkgs-unstable.razergenie
  ];

  services.udev.packages = [ pkgs.streamdeck-ui ]; # For Stream Controller

  services.flatpak = {
    packages = [
      # "com.core447.StreamController"
    ];
  };
  services.nix-serve = {
    enable = false;
    package = pkgs.nix-serve-ng;
  };

  services.lact.enable = true;

  hardware.openrazer = {
    enable = true;
    packages.daemon = pkgs-unstable.python314Packages.openrazer-daemon;
    users = [
      "daniel"
    ];
  };
}
