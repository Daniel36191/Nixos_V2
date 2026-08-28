{
  inputs,
  pkgs,
  host,
  ...
}:
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default # Cli tool
  ];

  age.secrets = {
    "tailscale-${host}".file = ./tailscale-${host}.age;
    "ssh-${host}".file = ./ssh-${host}.age;

    "ssh-borg.age".file = ./ssh-borg.age;
  };
}
