{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.home.user-defaults;

in
{
  config = lib.mkIf mod.enable {
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "${pkgs.nautilus}/share/applications/org.gnome.Nautilus.desktop";
    };
  };
}
