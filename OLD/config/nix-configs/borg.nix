{
  vars,
  config,
  ...
}:
let
in
{
  services.borgbackup = {
    repos = {
      "${vars.hostname}" = {
        path = "/media/archive";
        group = "borg";
        user = "borg";
        authorizedKeys = [
          ## Self 
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkEIF1uArLiuaprNRXunzU+g3iV0+HWS3qzqQ5vL2Ey borg@nixos-pc"
          ## Lillypond
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7LbQUuS7fN6k0oY1lX+ZrTo15dQaQRigln+5jzu3r3 lillypond@lillypond"
        ];
      };
    };
  };

  ################
  ## SSH & User ##
  ################

    users.users = {
    "borg" = {
      isSystemUser = true;
      createHome = false;
      home = config.services.borgbackup.repos."${vars.hostname}".path;
      openssh.authorizedKeys.keys = [ 
        "${(import ../pc/variables-pc.nix).ssh-public-key}"
        "${(import ../laptop/variables-laptop.nix).ssh-public-key}"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIv464AZB6omIM7lrgKqZKnK62iP72YOrcYsV9pplsyF lillypond@lillypond"
      ];
    };
  };

  age.secrets = {
    "ssh-borg" = {
      path = "/home/borg/.ssh/ssh-borg";
      owner = "borg";
      mode = "600";
    };
  };

  ## SSH Client
  home-manager.users."borg" = let ssh-private = config.age.secrets."ssh-borg"; in { ssh-public-key, ... }: {
    home.file.".ssh/ssh-borg.pub" = { text = ssh-public-key; force = true; };
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          port = 22;
          identityFile = ssh-private.path;
          forwardAgent = false;
          addKeysToAgent = "yes";
          compression = true;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no"; 
        };
      };
    };
  };
}