{
  config,
  fun,
  lib,
  pkgs,
  inputs,
  ...
}:
let
    mod = fun.configSelf __curPos.file;
in
{
  config = lib.mkIf mod.enable {
    home.packages = [
      inputs.quickshell.packages.${pkgs.system}.default
    ];
  };
}
