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

  xdg.desktopEntries.windows = {
    name = "Windows";
    icon = "/home/daniel/Nixos/config/hm-configs/desktop-files/windows.png"; ## Can't be releative??? WHY
    exec = "${pkgs.writeShellScript "windows-reboot" ''
        ${pkgs.grub2}/bin/grub-reboot "Windows Boot Manager (on /dev/sdb1)" \&& ${pkgs.systemd}/bin/reboot
    ''}";
    terminal = false;
    type = "Application";
    categories = ["Application"];
  };

}
