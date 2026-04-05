{
  pkgs,
  inputs,
  ...
}:
let
in
{
    environment.systemPackages = with pkgs; [
        pdfarranger
        onlyoffice-desktopeditors
        obsidian ## Notes
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
}