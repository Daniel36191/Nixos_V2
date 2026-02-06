{
  inputs,
  lib,
  nix-host,
  pkgs,
  ...
}:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
    };
  };
  
  home.packages = with pkgs; [
  	inputs.dms.packages.${pkgs.system}.dms-shell
  ];

  ## Place Settings File
  # home.file.".config/DankMaterialShell/settings.json".text = let
  # machine = if nix-host == "pc"
  #   then
  #      builtins.readFile ./pc.json
  #   else
  #     builtins.readFile ./laptop.json;
  # in
  # lib.strings.concatStrings [
  #   machine
  # ];
}
