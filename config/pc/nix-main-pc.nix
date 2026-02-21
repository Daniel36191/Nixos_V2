{
  ...
}:
{
  ## Temporary this is from gnome
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
    "olm-3.2.16"
  ];
  imports = [
    ## Apps
    # ../nix-configs/vm.nix
    # ../nix-configs/containers.nix
    # ../nix-configs/proxmox.nix
    ../nix-configs/vr.nix
    ../nix-configs/apps.nix
    # ../nix-configs/samba.nix
    ../nix-configs/tailscale.nix
    ../nix-configs/syncthing.nix
    ../nix-configs/games.nix
    ../nix-configs/creative.nix
    ../nix-configs/coding.nix
    ../nix-configs/apps-pc.nix
    # ../nix-configs/apps-laptop.nix
    # ../nix-configs/zerotier.nix
    ../nix-configs/office.nix
    # ../nix-configs/brightness.nix
    # ../nix-configs/clam-av.nix

    ## App Configs
    ../nix-configs/app-configs/starship.nix
    ../nix-configs/app-configs/fish.nix
    ../nix-configs/app-configs/shell.nix ## fix the cleannix command to use nh

    ## Theme
    ../nix-configs/theme.nix ## blacklist libreofficr from stylix
    ../nix-configs/sound.nix
    ../nix-configs/wm-modules/hyprland.nix
    ../nix-configs/wm-modules/hyprdynamicmonitors/monitors.nix
    # ../nix-configs/wm-modules/kde.nix

    ## Core
    ../nix-main.nix
    ../nix-configs/users.nix
    ../nix-configs/defaults.nix
    ../nix-configs/core/devices.nix
    ../nix-configs/core/devices-pc.nix
    ../nix-configs/core/boot.nix
    ../nix-configs/core/core-services.nix
    ../../secrets/secrets-nix.nix

    ## To Be Cleaned
    ../../modules/nvidia-drivers.nix

    ## No Touch
    ../nix-configs/core/hardware-pc.nix
  ];

  ####################
  ## Profile Config ##
  ####################
  environment.variables = {
		NIX_HOST = "pc";
	};

  ################
  ## Networking ##
  ################

  # networking = { 
  #   networkmanager = {
  #     insertNameservers = [
  #       # "192.168.0.141"
  #       "1.1.1.1"
  #     ];
  #   };
  #   resolvconf.enable = false; ## Needed for insertNameservers to work?
  # };


  ##################
  ## Boot Entries ##
  ##################
  boot.loader.grub.extraEntries =
    let
        ##run: sudo blkid -o export /dev/sd(xy of main windwos part(largest)) | grep UUID
        uuid = "CCF02DC0F02DB19E";

        ## lsblk, sda->hd0, sda1->gpt1
        win-drive = "hd1,gpt1";
        nix-drive = "hd0,gpt1";
    in
    ''
    menuentry "Windows" {
      insmod part_gpt
      insmod fat
      set root='${nix-drive}'
      if [ x$feature_platform_search_hint = xy ]; then
       search --no-floppy --fs-uuid --set=root --hint-bios=${win-drive} --hint-efi=${win-drive} --hint-baremetal=ahci0,gpt1  ${uuid}
      else
       search --no-floppy --fs-uuid --set=root ${uuid}
      fi
      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
    '';
}
