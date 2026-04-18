{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
   mod = fun.getMod config __curPos.file;

in
{
  config = lib.mkIf mod.enable {
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "${pkgs.nautilus}/share/applications/org.gnome.Nautilus.desktop";
    };
  };
}
