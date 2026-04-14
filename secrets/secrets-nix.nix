{
  inputs,
  pkgs,
  var,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default # Cli tool
  ];

  age.secrets = {
    "tailscale-${var.host}".file = ./tailscale-${var.host}.age;
    "ssh-${var.host}".file = ./ssh-${var.host}.age;

    "ssh-borg.age".file = ./ssh-borg.age;
  };
}
