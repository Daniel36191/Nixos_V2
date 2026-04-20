{
  config,
  lib,
  pkgs,
  var,
  ...
}:
let
  mod = config.mod.glances;
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
        "/home/${var.username}/.config/glances/glances.conf"
      ];
    };
  };
}
