{ config, pkgs, ... }:

{
environment.systemPackages = with pkgs; [
libvirt
qemu
virt-manager # optional for GUI
gnome-boxes
virt-viewer
libglvnd #??? for gl acc
];

# enable libvirt
virtualisation.libvirtd = {
  enable = true;
  onBoot = "ignore";
  onShutdown = "shutdown";

  qemu = {
  ovmf.enable = true;
  runAsRoot = true; # ths does noting
  };
};

# Enables VM connection
programs.dconf.profiles.user.databases = [
  { lockAll = true;

    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  }
];
}
