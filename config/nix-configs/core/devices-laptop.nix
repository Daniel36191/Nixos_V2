{
  ...
}:{
  import = [
    ./framework/amd.nix
    ./framework/workarounds.nix
  ];
  ## To update bios and hardware controlers
    services.fwupd.enable = true;

  ## For fingerprint support
  services.fprintd.enable = true;

  ## Custom udev rules to fix ethernet card
  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
  '';

  ## Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = true;

  config.boot = {
  extraModulePackages = with config.boot.kernelPackages; [ framework-laptop-kmod ];
  kernelModules = [ "cros_ec" "cros_ec_lpcs" ];
   };
}