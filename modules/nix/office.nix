{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  mod = config.mod.office;

in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with unstable; [
      pdfarranger
      onlyoffice-desktopeditors
      obsidian # Notes
    ];

    fonts.packages = with unstable; [
      corefonts
    ];

    services.flatpak = {
      packages = [
        "com.tdameritrade.ThinkOrSwim"
      ];
    };

    #################
    ## Thunderbird ## (E-Mail)
    #################
    programs.thunderbird = {
      enable = true;
    };
  };
}
