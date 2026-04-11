{
  ...
}:{
  nixpkgs.overlays = [
    (import ./red-hat-fonts.nix)
  ];
}