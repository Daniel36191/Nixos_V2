{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.modules.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};

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
