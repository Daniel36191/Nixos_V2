{
  config,
  fun,
  lib,
  pkgs,
  options,
  ...
}:
let
   mod = fun.getMod config __curPos.file;
in
{
  config = lib.mkIf mod.enable {
    ## Define users by nix
    users = {
      mutableUsers = true;
    };

    ## Locale Settings
    console.keyMap = "us";
    ## Set your time zone
    time.timeZone = "America/${config.mod.timeZone}";
    ## Set time server
    networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

    ## Select internationalisation properties
    i18n = {
      defaultLocale = config.mod.locale;
      extraLocaleSettings = {
        LC_ADDRESS = config.mod.locale;
        LC_IDENTIFICATION = config.mod.locale;
        LC_MEASUREMENT = config.mod.locale;
        LC_MONETARY = config.mod.locale;
        LC_NAME = config.mod.locale;
        LC_NUMERIC = config.mod.locale;
        LC_PAPER = config.mod.locale;
        LC_TELEPHONE = config.mod.locale;
        LC_TIME = config.mod.locale;
      };
    };
    users.users = {
      "${config.mod.username}" = {
        homeMode = "755";
        isNormalUser = true;
        description = "${config.mod.git.username}";
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
        ]
        ++ config.mod.ssh.authedKeys;
      };
    };
    nix.settings.trusted-users = [
      "root"
      "${config.mod.username}"
    ];
  };
}
