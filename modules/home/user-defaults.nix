{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};

in
{
  config = lib.mkIf mod.enable {
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "${pkgs.nautilus}/share/applications/org.gnome.Nautilus.desktop";
    };
  };
}
