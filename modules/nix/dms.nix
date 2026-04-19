{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
  mod = fun.configSelf config __curPos.file;

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
