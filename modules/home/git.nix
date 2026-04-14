{
  config,
  lib,
  pkgs,
  var,
  ...
}:
let
  mod = config.mod.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};
in
{
  config = lib.mkIf mod.enable {
    programs.git = {
      enable = true;
      settings.user = {
        Name = "${config.mod.git.username}";
        Email = "${config.mod.git.email}";
      };
    };
    programs = {
      gh.enable = true;
    };

    ## SSH Client
    home.file.".ssh/ssh-${var.host}.pub" = {
      text = config.mod.sshPublicLey;
      force = true;
    };
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          port = 22;
          identityFile = config.age.secrets."ssh-${var.host}".path;
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
