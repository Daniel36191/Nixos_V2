{
  lib,
  ...
}:
{
  config.hostConf = {
    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUbaQCPcnGcg26JmKGXEDUGDywf95UhziIQ7YIXkzYC daniel@nixos-pc";
  };
  options.hostConf = with lib; {
    sshPublicKey = mkOption {};
  };
}
