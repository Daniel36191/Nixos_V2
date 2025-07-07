{
  ...
}:
{
  imports = [
    ## Apps
    ./nix-configs/vm.nix
    ./nix-configs/containers.nix
    ./nix-configs/vr.nix
    ./nix-configs/apps.nix
    ./nix-configs/samba.nix

    ## App Configs
    ./nix-configs/app-configs/starship.nix
    ./nix-configs/app-configs/fish.nix
    ./nix-configs/app-configs/shell.nix

    ## Theme
    ./nix-configs/theme.nix
    ./nix-configs/sound.nix
    ./nix-configs/core/wm-modules/hyprland.nix

    ## Core
    ./nix-configs/users.nix
    ./nix-configs/core/devices.nix
    ./nix-configs/core/boot.nix
    ./nix-configs/core/core-services.nix

    ## To Be Cleaned
    ../modules/nvidia-drivers.nix

    ## No Touch
    ./nix-configs/core/hardware-configuration.nix
  ];

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
      PermitRootLogin = "yes"; # # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
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
    ];
    allowedUDPPorts = [
      5900
      25565
    ];
  };

  # services.tailscale = {
  #   enable = true;
  #   openFirewall = true;
  #   authKeyFile = ./tailscaleauthkey.key;
  #   extraSetFlags = [
  #     "--advertise-exit-node"
  #   ];
  # };

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
