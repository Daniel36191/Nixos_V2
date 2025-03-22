{
  config,
  pkgs,
  host,
  username,
  options,
  ...
}:
{
  imports = [
  ## Apps
  # ./nix-configs/vm.nix
  # ./nix-configs/vr.nix
  ./nix-configs/apps.nix

  ## Theme
  ./nix-configs/theme.nix
  ./nix-configs/sound.nix
  ./nix-configs/core/wm-modules/hyprland.nix

  ## Core
  ./nix-configs/users.nix
  ./nix-configs/code/devices.nix
  ./nix-configs/core/boot.nix


  ## To Be Cleaned
  ../modules/nvidia-drivers.nix
  ../modules/nvidia-prime-drivers.nix
  ../modules/vm-guest-services.nix
  ../modules/local-hardware-clock.nix

  ## No Touch
  ./nix-configs./hardware.nix
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

  ## Set your time zone
  time.timeZone = "America/New_York";
  ## Set time server
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  ## Select internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
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
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
