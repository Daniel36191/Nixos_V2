{
  pkgs,
  options,
  consoleKeyMap,
  gitUsername,
  timeZone,
  locale,
  username,
  nix-host,
  ...
}:
{
  ## Define users by nix
  users = {
    mutableUsers = true;
  };

  ## Locale Settings
  console.keyMap = consoleKeyMap;
  ## Set your time zone
  time.timeZone = timeZone;
  ## Set time server
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  ## Select internationalisation properties
  i18n = {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };
  };

  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "libvirt-qemu"
        "kvm"
        "input"
        "disk"
        "scanner"
        "lp"
        "docker"
        "podman"
        "video"
        "dialout"
      ];
    };
  };
}
