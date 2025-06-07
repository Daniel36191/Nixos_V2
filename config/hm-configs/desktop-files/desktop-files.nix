{ config, pkgs, ... }:

{
  xdg.desktopEntries.balatro = {
    name = "Balatro";
    exec = "love /home/daniel/Desktop/Games/Balatro_Love/Balatro.love";
    terminal = false;
    type = "Application";
    categories = ["Application"];
  };

  xdg.desktopEntries.cardinal = {
    name = "Cardinal";
    exec = "Cardinal";
    terminal = false;
    type = "Application";
    categories = ["Application"];
  };

  # xdg.desktopEntries.blender = {
  #   name = "Blender";
  #   exec = "steam steam://rungameid/365670";
  #   terminal = false;
  #   icon = "steam_icon_365670";
  #   type = "Application";
  #   categories = ["Application"];
  # };
}
