{
  pkgs,
  inputs,
  ...
}:
let
in
{
    environment.systemPackages = with pkgs; [
     houdini
    ];

    services.flatpak = {
    packages = [
    ];
  };
}
