{
  config,
  fun,
  lib,
  pkgs,
  ...
}:
let
  mod = fun.configSelf config __curPos.file;

in
{
  config = lib.mkIf mod.enable {
    programs.zoxide = {
      enable = true;
      flags = [
        "--no-cmd" # Remove z command
        "--cmd cd" # Replace cd command
      ];
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
