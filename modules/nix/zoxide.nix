{
  config,
  lib,
  ...
}:
let
  mod = config.modules.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};
in
{
  config = lib.mkIf mod.enable {
    programs.zoxide = {
      enable = true;
      flags = [
        "--no-cmd" ## Remove z command
        "--cmd cd"	## Replace cd command
      ];
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  }
}