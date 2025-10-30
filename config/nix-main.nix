{
  pkgs,
  ...
}:
{
  #########
  ## SSH ##
  #########

  services.openssh = {
    enable = true;
    ports = [ 54321 ];
    authorizedKeysInHomedir = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; ## Allows all users by default. Can be [ "user1" "user2" ]
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
    networkmanager = {
      enable = true;
      insertNameservers = [
        "192.168.0.141"
      ];
    };
    resolvconf.enable = false; ## Needed for insertNameservers to work?
    nat = {
      enable = true;
      enableIPv6 = true;
    };
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
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
        "https://192.168.8.184:5000"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
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
    ln -sf ${pkgs.bash}/bin/bash /bin/bash
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}