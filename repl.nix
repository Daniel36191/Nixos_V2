#! /usr/bin/env -S nix repl --file
let
  lib = (import <nixpkgs> { }).lib;
in
{
  rr = "hello repl :3";
}
