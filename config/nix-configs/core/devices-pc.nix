{
  pkgs,
  config,
  ...
}:
{
  ## Cpu
  services.auto-cpufreq = {
    enable = !config.programs.dms-shell.enable;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
  };

  fileSystems = {
    "/media/fat" = {
      device = "/dev/disk/by-uuid/01DA383CA1F608A0";
      fsType = "ntfs";
      options = [
        "defaults"
        "uid=1000"
        "gid=1000"
        "rw"
        "exec"
        "umask=000"
        "nofail"
      ];
    };

    "/media/archive" = {
      device = "/dev/disk/by-uuid/627038dc-7b4a-4469-8281-decae3b3cac4";
      fsType = "ext4";
      options = [
        "rw"
        "defaults"
        "nofail"
      ];
    };
  };
}
