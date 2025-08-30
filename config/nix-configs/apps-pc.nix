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
        lan-mouse # # Software KVM
    ];

    services.flatpak = {
    packages = [
        # "com.core447.StreamController"
    ];
  };
}