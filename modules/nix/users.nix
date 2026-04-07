{
  pkgs,
  config,
  options,
  nix-host,
  ...
}:
{
  ## Define users by nix
  users = {
    mutableUsers = true;
  };

  ## Locale Settings
  console.keyMap = "us";
  ## Set your time zone
  time.timeZone = "America/${config.usrConfig.timeZone}";
  ## Set time server
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  ## Select internationalisation properties
  i18n = {
    defaultLocale = config.usrConfig.locale;
    extraLocaleSettings = {
      LC_ADDRESS = config.usrConfig.locale;
      LC_IDENTIFICATION = config.usrConfig.locale;
      LC_MEASUREMENT = config.usrConfig.locale;
      LC_MONETARY = config.usrConfig.locale;
      LC_NAME = config.usrConfig.locale;
      LC_NUMERIC = config.usrConfig.locale;
      LC_PAPER = config.usrConfig.locale;
      LC_TELEPHONE = config.usrConfig.locale;
      LC_TIME = config.usrConfig.locale;
    };
  };
  users.users = {
    "${config.usrConfig.username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${config.usrConfig.git.username}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "libvirt-qemu"
        "kvm"
        "input"
        "keyd"
        "disk"
        "scanner"
        "lp"
        "docker"
        "podman"
        "video"
        "audio"
        "dialout"
        "pipewire"
        "realtime"
        "realtime"
        "seat"
        "tty"
        "render"
        "wayland"
        "dbus"
      ];
      openssh.authorizedKeys.keys = [ 
        "${(import ../pc/variables-pc.nix).ssh-public-key}"
        "${(import ../laptop/variables-laptop.nix).ssh-public-key}"
      ] ++ config.usrConfig.ssh.authedKeys;
    };
  };
  nix.settings.trusted-users = [
    "root"
    "${config.usrConfig.username}"
    ];
}
