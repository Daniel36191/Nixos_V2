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

      plugins = {
        FullSleepCOntrol = {
          enable = true;
          src = pkgs.fetchFromForgejo {
            domain = "git.lillypond.name";
            owner = "dmoeller";
            repo = "DMS-FullSleepControl";
            rev = "c24d30bac8d439b92bbe0774a8e683be511f05b8";
            sha256 = "sha256-qstL/gbkfGMKCii9FJib2O/RnH3WXvApVPVx2u8aTXQ=";
          };
        };
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
