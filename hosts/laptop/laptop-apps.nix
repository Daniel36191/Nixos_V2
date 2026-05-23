{
  pkgs,
  inputs,
  pkgs-personal,
  ...
}:
let
in
{
  environment.systemPackages = with pkgs; [
    framework-tool
    pkgs-personal.lulzbot-cura
    streamcontroller
  ];

  services.udev.packages = [ pkgs.streamdeck-ui ]; # For Stream Controller

  services.flatpak = {
    packages = [
    ];
  };

  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
  };
}
