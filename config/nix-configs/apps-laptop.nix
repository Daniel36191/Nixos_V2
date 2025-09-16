{
  pkgs,
  inputs,
  ...
}:
let
in
{
    environment.systemPackages = with pkgs; [
     framework-tool
    ];

    services.flatpak = {
    packages = [
    ];
  };
}
