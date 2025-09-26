{
  inputs,
  pkgs,
  nix-host,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default
  ];

  age.secrets = {
    tailscale.file = ./tailscale${nix-host}.age;
  };
}