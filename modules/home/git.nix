{
  pkgs,
  lib,
  osConfig,
  host,
  var,
  ...
}:
let
  mod = osConfig.mod.git;
in
{
  config = lib.mkIf mod.enable {
    programs.git = {
      enable = true;
      settings.user = {
        Name = "${var.git.username}";
        Email = "${var.git.email}";
      };
    };
    programs = {
      gh.enable = true;
    };

    ## SSH Client
    home.file.".ssh/ssh-${host}.pub" = {
      text = osConfig.hostConf.sshPublicKey;
      force = true;
    };
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          port = 22;
          identityFile = osConfig.age.secrets."ssh-${host}".path;
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
        "github.com" = {
          hostname = "github.com";
          port = 22;
          user = "git";
        };

        "ssh.lillypond.name" = {
          hostname = "ssh.lillypond.name";
          port = 2222;
          user = "forgejo";
        };

        "lillypond.local" = {
          hostname = "lillypond.local";
          port = 22;
          user = "lillypond";
        };

        "root.lillypond.local" = {
          hostname = "lillypond.local";
          port = 22;
          user = "root";
        };

        "lillypond-tailscale" = {
          hostname = "lillypond";
          port = 22;
          user = "lillypond";
        };

      };
    };
  };
}
