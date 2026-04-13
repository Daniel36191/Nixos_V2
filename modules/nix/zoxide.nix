{
  config,
  lib,
  ...
}:
let
in
{
  programs.zoxide = {
    enable = true;
    flags = [
      "--no-cmd" # # Remove z command
      "--cmd cd" # # Replace cd command
    ];
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
