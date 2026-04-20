{
  inputs,
  pkgs,
  host,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default # Cli tool
  ];

  age.secrets = {
    "tailscale-${host}".file = ./tailscale-${host}.age;
    "ssh-${host}".file = ./ssh-${host}.age;

    "ssh-borg.age".file = ./ssh-borg.age;
  };
}
