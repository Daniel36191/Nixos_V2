#! /usr/bin/env -S nix repl --file
let
  pkgs = (import <nixpkgs> { });
  lib = pkgs.lib;
  mod = config.mod.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};
in
{
  r = modFor ./modules;

}
