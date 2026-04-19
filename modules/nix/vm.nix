{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
    mod = fun.configSelf __curPos.file;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [
      libvirt
      qemu
      virt-viewer
      libglvnd
      virtio-win
      virtiofsd
    ];
    services.flatpak = {
      packages = [
        "com.usebottles.bottles"
      ];
    };

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
        runAsRoot = true; # ths does noting
      };
    };
    users.groups.libvirtd.members = [ "${config.mod.username}" ];

    ## Enables VM connection
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = [ "qemu:///system" ];
            uris = [ "qemu:///system" ];
          };
        };
      }
    ];
    hardware.enableRedistributableFirmware = true;

    ## Fix for https://github.com/nixos/nixpkgs/issues/378894
    ## Rewrite the hard links from nix/store to the new ones in /usr/share/qemu
    system.activationScripts.qemu = ''
      mkdir -p /usr/share/qemu
      cp -f ${pkgs.qemu}/share/qemu/edk2-i386-vars.fd /usr/share/qemu/edk2-i386-vars.fd
      cp -f ${pkgs.qemu}/share/qemu/edk2-x86_64-secure-code.fd /usr/share/qemu/edk2-x86_64-secure-code.fd
    '';
  };
}
