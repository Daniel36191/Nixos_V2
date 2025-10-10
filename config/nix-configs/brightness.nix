{
  pkgs,
  inputs,
  ...
}:
{
  services.clight = {
    enable = true;
    settings = {
      no_auto_calibration = true; ## Dissables autodim??
    };
  };
  environment.systemPackages = with pkgs; [
    clight-gui
  ];
}