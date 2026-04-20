{
  config,
  lib,
  pkgs,
  var,
  ...
}:
let
  mod = config.mod.samba;
in
{
  config = lib.mkIf mod.enable {
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          securityType = "user";
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
        };
        "nixos" = {
          "path" = "/home/${var.username}/Desktop/Share";
          "browseable" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "read only" = "no";
          "guest ok" = "yes";
          "valid users" = "${var.username}";
          "force user" = "${var.username}";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
