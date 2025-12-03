{
  inputs,
  pkgs,
  nix-host,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default ## Cli tool
  ];

  # age.secrets = {
  #   "tailscale-${nix-host}".file = ./tailscale-${nix-host}.age;
  # };
}