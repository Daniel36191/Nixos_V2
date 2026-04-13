{
  lib,
  ...
}:
with lib;
{
  options = {
    mod = {
      username = mkOption { };
      hostname = mkOption { };
      wallpaper = mkOption { };
      git = {
        username = mkOption { };
        email = mkOption { };
      };
      ssh.authedKeys = mkOption { };
      firewall = mkOption { };
      timeZone = mkOption { };
      locale = mkOption { };

      host = mkOption { };
      sshPublicKey = mkOption { };
    };
  };
}
