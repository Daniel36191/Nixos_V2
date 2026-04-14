#! /usr/bin/env -S nix repl --file
let
  pkgs = (import <nixpkgs> { });
  lib = pkgs.lib;
in
{
  r = "Hiiii repl~";
}
