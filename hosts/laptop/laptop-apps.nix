{
  pkgs,
  inputs,
  pkgs-pkgs-personal,
  ...
}:
let
in
{
  environment.systemPackages = with pkgs; [
    framework-tool
    pkgs-personal.lulzbot-cura
  ];

  services.flatpak = {
    packages = [
    ];
  };

  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
  };
}
