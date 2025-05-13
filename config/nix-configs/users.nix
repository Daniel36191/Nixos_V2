{
  pkgs,
  username,
  options,
  ...
}:

let
  inherit (import ../variables.nix)
  consoleKeyMap
  gitUsername
  timeZone
  shell
  ;
in
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
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
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
        "scanner"
        "lp"
        "docker"
        "video"
        "dialout"
      ];
      shell = with pkgs; shell;
      ignoreShellProgramCheck = true;
    };
  };
}
