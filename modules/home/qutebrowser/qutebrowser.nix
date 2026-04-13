{
  lib,
  ...
}:
let
  config = builtins.readFile ./config.yml;
in
{
  home.file.".config/qutebrowser/autoconfig.yml".text = lib.strings.concatStrings [ config ];
}
