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

  xdg.desktopEntries.windows = {
    name = "Windows";
    icon = "/home/daniel/Nixos/config/hm-configs/desktop-files/windows.png"; ## Can't be releative??? WHY
    exec = ''pkexec env "DISPLAY=\\$DISPLAY" "XAUTHORITY=\\$XAUTHORITY" sh -c "grub-reboot \\"Windows Boot Manager (on /dev/sdb1)\\"; reboot"''; ## Doesnt work?
    terminal = false;
    type = "Application";
    categories = ["Application"];
  };

}
