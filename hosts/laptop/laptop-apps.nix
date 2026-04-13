{
  pkgs,
  inputs,
  nixpkgs-personal,
  ...
}:
let
in
{
  environment.systemPackages = with pkgs; [
    framework-tool
    nixpkgs-personal.lulzbot-cura
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
