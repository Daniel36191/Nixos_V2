{
  pkgs,
  pkgs-unstable,
  nixpkgs-personal,
  ...
}:
let
in
{
    environment.systemPackages = with pkgs; [
        streamcontroller
        nixpkgs-personal.lulzbot-cura
        # lan-mouse ## Software KVM
    ];

    services.udev.packages = [ pkgs.streamdeck-ui ]; ## For Stream Controller

    services.flatpak = {
    packages = [
        # "com.core447.StreamController"
    ];
  };
    services.nix-serve = {
    enable = false;
    package = pkgs.nix-serve-ng;
  };
}
