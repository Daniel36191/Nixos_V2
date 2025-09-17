{
  pkgs,
  inputs,
  ...
}:
let
  lulzbot-cura = pkgs.callPackage ../../custom-apps/lulzbot-cura.nix { };
in
{
    environment.systemPackages = with pkgs; [
     framework-tool
     lulzbot-cura
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
