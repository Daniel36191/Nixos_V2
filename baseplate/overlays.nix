{
  ...
}:
{
  nixpkgs.overlays = [
    (import ../modules/overlays/red-hat-fonts.nix)
  ];
}
