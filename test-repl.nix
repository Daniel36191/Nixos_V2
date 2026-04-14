let
  lib = (import <nixpkgs> { }).lib;
  importsModules =
    dir:
    lib.filter (f: builtins.match ".*\\.nix" (baseNameOf (toString f)) != null) (
      lib.filesystem.listFilesRecursive dir
    );
in
{
  r = importsModules ./modules/nix;
}
