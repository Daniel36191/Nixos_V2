{
  pkgs,
  ...
}:
let
  inherit (import ../variables.nix)
  username
  ;
in
{
environment.systemPackages = with pkgs; [
libvirt
qemu
virt-viewer
libglvnd
];

## Virt-manager GUI
programs.virt-manager.enable = true;

## Spice interface
virtualisation.spiceUSBRedirection.enable = true;

## Enable Libvirt
virtualisation.libvirtd = {
  enable = true;
  onBoot = "ignore";
  onShutdown = "shutdown";

  qemu = {
  ovmf.enable = true;
  runAsRoot = true; # ths does noting
  };
};
users.groups.libvirtd.members = ["${username}"];

## Enables VM connection
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
