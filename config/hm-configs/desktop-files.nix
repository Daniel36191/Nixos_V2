{ config, ... }:

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
}
