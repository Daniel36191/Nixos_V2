{
  config,
  lib,
  var,
  host,
  ...
}:
let
  mod = config.mod.git;
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
        PermitRootLogin = "yes"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
        PubkeyAuthentication = "yes";
      };
    };

    age.secrets = {
      "ssh-${host}" = {
        path = "/home/${var.username}/.ssh/id_ed25519";
        owner = var.username;
        mode = "600";
      };
    };
  };
}
