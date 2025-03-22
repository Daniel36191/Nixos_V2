{
  config,
  pkgs,
  host,
  username,
  options,
  ...
}:
{
    imports = [
      ./nix-configs/config.nix
    ];
}