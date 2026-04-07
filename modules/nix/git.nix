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
    "ssh-${config.hostConfig.host}" = {
      path = "/home/${config.usrConfig.username}/.ssh/ssh-${config.hostConfig.host}";
      owner = config.usrConfig.username;
      mode = "600";
    };
  };

}