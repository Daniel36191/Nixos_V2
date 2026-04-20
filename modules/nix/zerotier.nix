{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.nix.zerotier;

in
{
  config = lib.mkIf mod.enable {
    services.zerotierone = {
      enable = true;
      port = 30056;

      joinNetworks = [
      ];
    };
  };
}
