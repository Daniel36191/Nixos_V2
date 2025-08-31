{
  ...
}:
{
## Temporary this is from gnome
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];
  imports = [
    ## Apps
    ./nix-configs/vm.nix
    ./nix-configs/containers.nix
    ./nix-configs/vr.nix
    ./nix-configs/apps.nix
    ./nix-configs/samba.nix
    # ./nix-configs/tailscale.nix ##Encript with sops nix
    ./nix-configs/syncthing.nix
    ./nix-configs/games.nix
    ./nix-configs/creative.nix
    ./nix-configs/coding.nix
    ./nix-configs/apps-pc.nix
    # ./nix-configs/apps-laptop.nix
    ./nix-configs/zerotier.nix
    ./nix-configs/office.nix
    ./nix-configs/brightness.nix

    ## App Configs
    ./nix-configs/app-configs/starship.nix
    ./nix-configs/app-configs/fish.nix
    ./nix-configs/app-configs/shell.nix ## fix the cleannix command to use nh

    ## Theme
    ./nix-configs/theme.nix ##blacklist libreofficr from stylix
    ./nix-configs/sound.nix
    ./nix-configs/wm-modules/hyprland.nix

    ## Core
    ./nix-configs/users.nix
    ./nix-configs/defaults.nix
    ./nix-configs/core/devices.nix
    ./nix-configs/core/boot.nix
    ./nix-configs/core/core-services.nix

    ## To Be Cleaned
    ../modules/nvidia-drivers.nix

    ## No Touch
    ./nix-configs/core/hardware-pc.nix
  ];

  ####################
  ## Profile Config ##
  ####################
  environment.shellAliases = {
      NIX_HOST = "export NIX_HOST=pc";
    };


  #########
  ## SSH ##
  #########
  services.openssh = {
    enable = true;
    ports = [ 54321 ];
    authorizedKeysInHomedir = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "yes"; ## "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      PubkeyAuthentication = "yes";
    };
  };

  ####################
  ## Port Forwading ##
  ####################

  networking.firewall = {
    allowedTCPPorts = [
      5900
      25565
      54321
    ];
    allowedUDPPorts = [
      5900
      25565
      54321
    ];
  };

  ################
  ## Networking ##
  ################

  networking = {
    nameservers = [ "192.168.0.141" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };
  environment.etc = {
    "resolv.conf".text = "\nnameserver 192.168.0.141\n
  ";
  };


  ##################
  ## Boot Entries ##
  ##################
  boot.loader.grub.extraEntries =
    let
        ##run: sudo blkid -o export /dev/sd(xy of main windwos part(largest)) | grep UUID
        uuid = "CCF02DC0F02DB19E";

        ## lsblk, sda->hd0, sda1->gpt1
        drive = "hd1,gpt1";
    in
    ''
    menuentry "Windows" {
      insmod part_gpt
      insmod fat
      set root='hd0,gpt1'
      if [ x$feature_platform_search_hint = xy ]; then
       search --no-floppy --fs-uuid --set=root --hint-bios=${drive} --hint-efi=${drive} --hint-baremetal=ahci0,gpt1  ${uuid}
      else
       search --no-floppy --fs-uuid --set=root ${uuid}
      fi
      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
    '';


  ###########
  ## Nixos ##
  ###########

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  ## Compatibility
  system.activationScripts.binBash = ''
    ln -sf /run/current-system/sw/bin/bash /bin/bash
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
