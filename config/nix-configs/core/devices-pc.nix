{
  pkgs,
  ...
}:
{
  ## Cpu
  services.auto-cpufreq = {
    enable = true;
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
      device = "/dev/disk/by-uuid/c0543458-dc57-4e01-aeba-63c85cabc722";
      fsType = "btrfs";
      options = [
        "defaults"
        "exec"
        "rw"
        "nofail"
        "compress=zstd:10"
      ];
    };
  };
}