{
  pkgs,
  ...
}:
let
in
{
  environment.systemPackages = with pkgs; [
    usb-modeswitch
  ];

  ## Logitech G920 Wheel
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

  ## Logitech
  hardware.logitech.wireless = {
    enable = false;
    enableGraphical = false;
  };

  ## Document Scanners
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  ## Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        SecureConnections = "off";
      };
    };
  };
  services.blueman.enable = true;

  ## Rebind CapsLock to Super
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "layer(meta)";
          };
        };
      };
    };
  };
}
