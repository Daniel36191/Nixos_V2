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
    # services.clight = {
    #   enable = true;
    #   settings = {
    #     backlight.no_auto_calibration = true; ## Should dissable autodim but doesn't
    #   };
    # };
    environment.systemPackages = with pkgs; [
      # clight-gui
      brightnessctl
    ];
  };
}
