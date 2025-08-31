{
  pkgs,
  inputs,
  ...
}:
{
  services.clight = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    clight-gui
  ];
}