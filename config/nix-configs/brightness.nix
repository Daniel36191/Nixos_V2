{
  pkgs,
  inputs,
  ...
}:
{
  services.clight = {
    enable = true;
    settings = {
      backlight.no_auto_calibration = true; ## Dissables autodim??
    };
  };
  environment.systemPackages = with pkgs; [
    clight-gui
    brightnessctl
  ];
}