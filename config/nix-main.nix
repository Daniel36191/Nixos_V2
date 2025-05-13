{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  ...
}:
{
  imports = [
  ## Apps
  # ./nix-configs/vm.nix
  ./nix-configs/vr.nix
  ./nix-configs/apps.nix

  ## App Configs
  ./nix-configs/app-configs/starship.nix

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

  ## WIP
  ./nix-configs/config.nix

  ## No Touch
  ./nix-configs/core/hardware-configuration.nix
  ];

  #########
  ## SSH ##
  #########
  services.openssh = {
    enable = true;
    # ports = [ 54321 ];
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


  ############
  ## Locale ##
  ############

  ## Rebind CapsLock to Super
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "leftmeta";
          };
        };
      };
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
          "https://cuda-maintainers.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
