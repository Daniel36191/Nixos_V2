{
  config,
  fun,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  mod = fun.configSelf config __curPos.file;

in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [
      pdfarranger
      onlyoffice-desktopeditors
      obsidian # Notes
    ];

    fonts.packages = with pkgs; [
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
