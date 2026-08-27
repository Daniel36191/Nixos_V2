{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with unstable; [
    nix-prefetch-scripts # Every Prefetch
  ];

  shellHook = "";
}
