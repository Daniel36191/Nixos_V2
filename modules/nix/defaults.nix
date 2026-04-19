{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
    mod = fun.configSelf __curPos.file;
in
{
  config = lib.mkIf mod.enable {
    xdg.mime = {
      enable = true;
      defaultApplications = {
        ## Use this to find the names: cd /run/current-system/sw/share/mime/ && tree | grep -i ""
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
        "inode/directory" = "${pkgs.nautilus}/share/applications/org.gnome.Nautilus.desktop";
        "x-scheme-handler/acmanager" = "assetto-corsa.desktop";
      };
    };
  };
}
