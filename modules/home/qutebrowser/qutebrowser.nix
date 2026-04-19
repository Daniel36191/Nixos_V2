{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
    mod = fun.configSelf __curPos.file;

  config = builtins.readFile ./config.yml;
in
{
  config = lib.mkIf mod.enable {
    home.file.".config/qutebrowser/autoconfig.yml".text = lib.strings.concatStrings [ config ];
  };
}
