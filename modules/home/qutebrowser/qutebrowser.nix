{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};

  config = builtins.readFile ./config.yml;
in
{
  config = lib.mkIf mod.enable {
    home.file.".config/qutebrowser/autoconfig.yml".text = lib.strings.concatStrings [ config ];
  };
}
