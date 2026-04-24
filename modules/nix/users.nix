{
  config,
  lib,
  pkgs,
  options,
  var,
  ...
}:
let
  mod = config.mod.users;
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
    time.timeZone = "America/${var.timeZone}";
    ## Set time server
    networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

    ## Select internationalisation properties
    i18n = {
      defaultLocale = var.locale;
      extraLocaleSettings = {
        LC_ADDRESS = var.locale;
        LC_IDENTIFICATION = var.locale;
        LC_MEASUREMENT = var.locale;
        LC_MONETARY = var.locale;
        LC_NAME = var.locale;
        LC_NUMERIC = var.locale;
        LC_PAPER = var.locale;
        LC_TELEPHONE = var.locale;
        LC_TIME = var.locale;
      };
    };
    users.users = {
      "${var.username}" = {
        homeMode = "755";
        isNormalUser = true;
        description = "${var.git.username}";
        extraGroups = [
          "networkmanager"
          "wheel"
          "libvirtd"
          "libvirt"
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
        ++ var.ssh.authedKeys;
      };
    };
    nix.settings.trusted-users = [
      "root"
      "${var.username}"
    ];
  };
}
