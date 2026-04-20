{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.home.qutebrowser;

  config = builtins.readFile ./config.yml;
in
{
  config = lib.mkIf mod.enable {
    home.file.".config/qutebrowser/autoconfig.yml".text = lib.strings.concatStrings [ config ];
  };
}
