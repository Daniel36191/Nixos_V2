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
    services.proxmox-ve = {
      enable = true;
      ipAddress = "192.168.0.1";
    };

    nix = {
      settings = {
        substituters = [
          "https://cache.saumon.network/proxmox-nixos"
        ];
        trusted-public-keys = [
          "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
        ];
      };
    };
  };
}
