{
  inputs,
  pkgs,
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
  
  home.packages = [
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
