{
  pkgs,
  inputs,
  ...
}:
let
in
{
    environment.systemPackages = with pkgs; [
    ];

    services.flatpak = {
    packages = [
    ];
  };
}