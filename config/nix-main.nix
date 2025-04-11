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
  ./nix-configs/vr.nix
  ./nix-configs/apps.nix

  ## Theme
  ./nix-configs/theme.nix
  ./nix-configs/sound.nix
  ./nix-configs/core/wm-modules/hyprland.nix

  ## Core
  ./nix-configs/users.nix
  ./nix-configs/core/devices.nix
  ./nix-configs/core/boot.nix


  ## To Be Cleaned
  ../modules/nvidia-drivers.nix
  ../modules/nvidia-prime-drivers.nix
  ../modules/vm-guest-services.nix
  ../modules/local-hardware-clock.nix

  ## WIP
  ./nix-configs/config.nix

  ## No Touch
  ./nix-configs/hardware.nix
  ];


  environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
  WLR_NO_HARDWARE_CURSORS = "1";
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  LIBVA_DRIVER_NAME = "nvidia";
  XDG_SESSION_TYPE = "wayland";
  QT_QPA_PLATFORM = "wayland;xcb";
  QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  GDK_BACKEND = "wayland,x11";
  MOZ_ENABLE_WAYLAND = "1";
  BRAVE_ENABLE_WAYLAND_IME = "1";
  };

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
