{
  pkgs,
  inputs,
  ...
}:
let
in
{
    environment.systemPackages = with pkgs; [
        streamcontroller
        # lan-mouse ## Software KVM
    ];

    services.udev.packages = [ pkgs.streamdeck-ui ]; ## For Stream Controller

    services.flatpak = {
    packages = [
        # "com.core447.StreamController"
    ];
  };
}