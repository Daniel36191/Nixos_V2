{
  ...
}:
{
  xdg.mime = {
    enable = true;
    defaultApplications = {
      ## Use this to find the names: cd /run/current-system/sw/share/mime/ && tree | grep -i ""
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "x-scheme-handler/acmanager" = "assetto-corsa.desktop";
    };
  };
}
