{
  pkgs,
  ...
}:
let
in
{
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "${pkgs.nautilus}/share/applications/org.gnome.Nautilus.desktop";
  };
}
