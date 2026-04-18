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
    # xdg.desktopEntries.balatro = {
    #   name = "Balatro";
    #   exec = "love /home/daniel/Desktop/Games/Balatro_Love/Balatro.love";
    #   terminal = false;
    #   type = "Application";
    #   categories = [ "Application" ];
    # };

    xdg.desktopEntries.cardinal = {
      name = "Cardinal";
      exec = "Cardinal";
      terminal = false;
      type = "Application";
      categories = [ "Application" ];
    };

    xdg.desktopEntries.Orca = {
      name = "Slicer Orca Fixed";
      exec = "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json orca-slicer";
      terminal = false;
      type = "Application";
      categories = [ "Application" ];
    };

    xdg.desktopEntries.Freecad = {
      name = "FreeCad Fixed";
      exec = "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json freecad";
      terminal = false;
      type = "Application";
      categories = [ "Application" ];
    };

    xdg.desktopEntries.hyprpanel = {
      name = "HyprPanel Settings";
      exec = "hyprpanel toggleWindow settings-dialog";
      terminal = false;
      type = "Application";
      categories = [ "Application" ];
    };

    xdg.desktopEntries.alcom = {
      name = "ALCOM Fixed";
      exec = "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json ALCOM";
      terminal = false;
      type = "Application";
      categories = [ "Application" ];
    };

    xdg.desktopEntries.gale = {
      name = "Gale Fixed";
      exec = "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json gale";
      terminal = false;
      type = "Application";
      categories = [ "Application" ];
    };

    xdg.desktopEntries.assetto-corsa = {
      name = "Assetto Corsa";
      exec = "steam steam://rungameid/244210 %u";
      icon = "steam_icon_244210";
      comment = "Assetto Corsa Racing Simulator";
      categories = [
        "Game"
        "Simulation"
      ];
      mimeType = [ "x-scheme-handler/acmanager" ];
    };
  };
}
