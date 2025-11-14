{
  inputs,
  lib,
  nix-host,
  ...
}:
{
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];
  programs.dankMaterialShell = {
    enable = true;
    systemd = {
      enable = true;
    };
  };

  ## Place Settings File
  home.file.".config/DankMaterialShell/settings.json".text = let
  main = builtins.readFile ./main.conf;
  machine = if nix-host == "pc"
    then
       builtins.readFile ./pc.conf
    else
      builtins.readFile ./laptop.conf;
  in
  lib.strings.concatStrings [
    main
    machine
  ];
}