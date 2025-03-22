{
  config,
  pkgs,
  host,
  username,
  options,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ## Devices
    usb-modeswitch
  ];

  #############
  ## Devices ##
  #############

  # Logitech wheel in pc mode
  services.udev.extraRules = ''
    # Logitech G920 Racing Wheel
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 046d -p c261 -c /etc/usb_modeswitch.d/046d:c261"
  '';
  environment.etc."usb_modeswitch.d/046d:c261".text = ''
    # Logitech G920 Racing Wheel
    DefaultVendor=046d
    DefaultProduct=c261
    MessageEndpoint=01
    ResponseEndpoint=01
    TargetClass=0x03
    MessageContent="0f00010142"
  '';

  ## Extra Logitech
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  ## Adb
  programs.adb.enable = true;

  ## Scanners
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  ## Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
}
