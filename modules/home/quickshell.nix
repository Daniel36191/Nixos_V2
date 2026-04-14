{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  mod = config.mod.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};
in
{
  config = lib.mkIf mod.enable {
    home.packages = [
      inputs.quickshell.packages.${pkgs.system}.default
    ];
  };
}
