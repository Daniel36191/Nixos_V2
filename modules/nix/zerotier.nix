{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
  mod = fun.configSelf config __curPos.file;

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
