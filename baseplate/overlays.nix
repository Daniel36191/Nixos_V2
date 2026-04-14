{
  lib,
  ...
}:
let
  importOverlays = dir: map import (lib.filesystem.listFilesRecursive dir);
in
{
  nixpkgs.overlays = importOverlays ../modules/overlays;
}
