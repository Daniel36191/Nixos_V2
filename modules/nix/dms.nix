{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.dms;
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
