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


  #########
  ## SSH ##
  #########

  ## SSH Server
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    authorizedKeysInHomedir = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; ## Allows all users by default. Can be [ "user1" "user2" ]
      X11Forwarding = false;
      PermitRootLogin = "yes"; ## "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      PubkeyAuthentication = "yes";
    };
  };

  age.secrets = {
    "ssh-${nix-host}" = {
      path = "/home/${config.usrConfig.username}/.ssh/ssh-${nix-host}";
      owner = config.usrConfig.username;
      mode = "600";
    };
  };

  ## SSH Client
  home-manager.users.${config.usrConfig.username} = let ssh-private = config.age.secrets."ssh-${nix-host}"; in { pkgs, config, ssh-public-key, ... }: {
    home.file.".ssh/ssh-${nix-host}.pub" = { text = ssh-public-key; force = true; };
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          port = 22;
          identityFile = ssh-private.path;
          forwardAgent = false;
          addKeysToAgent = "yes";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no"; 
        };

        "lillypond.local" = {
          hostname = "lillypond.local";
          port = 22;
          user = "lillypond";
        };

        "lillypond-tailscale" = {
          hostname = "lillypond";
          port = 22;
          user = "lillypond";
        };

        "github.com" = {
          hostname = "github.com";
          port = 22;
          user = "git";
        };
      };
    };
  };
}
