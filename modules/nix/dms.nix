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

      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      enableDynamicTheming = true;
      enableClipboardPaste = true;
      enableSystemMonitoring = true;
      enableVPN = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
    };
  };
}
