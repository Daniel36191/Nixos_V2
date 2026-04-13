{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.modules.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};

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
