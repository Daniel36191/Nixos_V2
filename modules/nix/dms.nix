{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};

in
{
  config = lib.mkIf mod.enable {
    programs.dms-shell = {
      enable = true;

      enableDynamicTheming = false;
      enableClipboardPaste = false;
    };
  };
}
