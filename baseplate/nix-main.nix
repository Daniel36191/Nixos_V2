{
  pkgs,
  ...
}:
{
  imports = [
    ./options.nix
    ./module-options.nix
    ./user-config.nix
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
    "olm-3.2.16"
  ];
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


  ###########
  ## Nixos ##
  ###########

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
        "https://passivelemon.cachix.org"
        # "https://192.168.0.248:5000"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "passivelemon.cachix.org-1:ScYjLCvvLi70S95SMMr8lMilpZHuafLP3CK/nZ9AaXM="
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
  # this value at the release version of the first install of this system
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";
}
