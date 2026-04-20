{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.nix.zoxide;
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
