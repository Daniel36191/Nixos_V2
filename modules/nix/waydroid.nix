{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.waydroid;
in
{
  config = lib.mkIf mod.enable {
    virtualisation.waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
  };
}
