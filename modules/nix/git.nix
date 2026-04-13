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
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      authorizedKeysInHomedir = true;
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null;
        X11Forwarding = false;
        PermitRootLogin = "yes"; # # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
        PubkeyAuthentication = "yes";
      };
    };

    age.secrets = {
      "ssh-${config.mod.host}" = {
        path = "/home/${config.mod.username}/.ssh/ssh-${config.mod.host}";
        owner = config.mod.username;
        mode = "600";
      };
    };
  };
}
