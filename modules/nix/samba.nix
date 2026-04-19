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
          "path" = "/home/${config.mod.username}/Desktop/Share";
          "browseable" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "read only" = "no";
          "guest ok" = "yes";
          "valid users" = "${config.mod.username}";
          "force user" = "${config.mod.username}";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
