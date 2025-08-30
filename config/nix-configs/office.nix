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
        onlyoffice-bin
        obsidian ## Notes
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