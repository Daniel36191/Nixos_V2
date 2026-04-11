{
  inputs,
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default ## Cli tool
  ];

  age.secrets = {
    "tailscale-${config.mod.host}".file = ./tailscale-${config.mod.host}.age;
    "ssh-${config.mod.host}".file = ./ssh-${config.mod.host}.age;

    "ssh-borg.age".file = ./ssh-borg.age;
  };
}