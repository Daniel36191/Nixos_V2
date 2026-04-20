{
  config,
  lib,
  osConfig,
  pkgs,
  inputs,
  ...
}:
let
  mod = osConfig.mod.quickshell;
in
{
  config = lib.mkIf mod.enable {
    home.packages = [
      inputs.quickshell.packages.${pkgs.system}.default
    ];
  };
}
