{
  lib,
  ...
}:
with lib;
{  
  options = {
    usrConfig = {
      username = mkOption {};
      hostname = mkOption {};
      git = {
        username = mkOption {};
        email = mkOption {};
      };
      ssh.authedKeys = mkOption {};
      firewall = mkOption {};
      timeZone = mkOption {};
      locale = mkOption {};
    };
    

    hostConfig = let
      extra = {
        host = mkOption {};
        sshPublicKey = mkOption {};
      };
      nixFiles = 
    in {

    };


  };
}
