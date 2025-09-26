{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default
  ];

  age.secrets = {
    tailscale.file = ./tailscale.age;
  };
}