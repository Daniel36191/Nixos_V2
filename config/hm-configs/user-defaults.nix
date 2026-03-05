{
  pkgs,
  ...
}:
let
in
{
  xdg.mme.defaultApplications = {
    "inode/directory" = "${pkgs.nautilus}/share/applications/org.gnome.Nautilus.desktop";
  };
}