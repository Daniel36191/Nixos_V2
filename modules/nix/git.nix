{
  config,
  ...
}:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    authorizedKeysInHomedir = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      X11Forwarding = false;
      PermitRootLogin = "yes"; ## "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
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

}