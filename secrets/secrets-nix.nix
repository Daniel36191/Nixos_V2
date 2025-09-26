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

  age.secrets = let
    tailscale-host = "tailscale-${nix-host}";
    in {
    tailscale-host.file = ./tailscale-${nix-host}.age;
  };
}