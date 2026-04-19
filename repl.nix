#! /usr/bin/env -S nix repl --file
let
  lib = (import <nixpkgs> {}).lib;

in
{
  r = "hello repl :3";
  rr = __curPos;
}
