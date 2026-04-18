{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
   mod = fun.getMod config __curPos.file;

in
{
  config = lib.mkIf mod.enable {
    services.glances = {
      enable = true;
      openFirewall = true;
      port = 61208;
      extraArgs = [
        "--webserver"
        "-C"
        "/home/${config.mod.username}/.config/glances/glances.conf"
      ];
    };
  };
}
