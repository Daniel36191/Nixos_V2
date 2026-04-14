{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nix-prefetch-scripts # Every Prefetch
  ];

  shellHook = "";
}
