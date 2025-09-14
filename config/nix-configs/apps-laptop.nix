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
     framework-tool
    ];

    services.flatpak = {
    packages = [
    ];
  };
}
