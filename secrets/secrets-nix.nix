{
  inputs,
  pkgs,
  host,
  ...
}:
{
  environment.systemPackages = with unstable; [
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default # Cli tool
  ];

  age.secrets = {
    "tailscale-${host}".file = ./tailscale-${host}.age;
    "ssh-${host}".file = ./ssh-${host}.age;

    "ssh-borg.age".file = ./ssh-borg.age;
  };
}
