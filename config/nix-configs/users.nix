{
  pkgs,
  config,
  options,
  consoleKeyMap,
  gitUsername,
  timeZone,
  locale,
  username,
  ssh-public-key,
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
        "keyd"
        "disk"
        "scanner"
        "lp"
        "docker"
        "podman"
        "video"
        "audio"
        "dialout"
      ];
      openssh.authorizedKeys.keys = [ 
        "${(import ../pc/variables-pc.nix).ssh-public-key}"
        "${(import ../laptop/variables-laptop.nix).ssh-public-key}"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEGNxyup7BAE63kcI0Ja8LNlibwi2p2NGA98W2qzlLdf flerouwu@hiroko"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIv464AZB6omIM7lrgKqZKnK62iP72YOrcYsV9pplsyF lillypond@lillypond"
      ];
    };
  };
  nix.settings.trusted-users = [
    "root"
    "${username}"
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
      path = "/home/${username}/.ssh/ssh-${nix-host}";
      owner = username;
      mode = "600";
    };
  };

  ## SSH Client
  home-manager.users.${username} = let ssh-private = config.age.secrets."ssh-${nix-host}"; in { pkgs, config, ssh-public-key, ... }: {
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
