{
  pkgs,
  var,
  ...
}:
{
  ## Networking
  networking = {
    networkmanager.enable = true;
    hostName = var.hostname;

    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    firewall.enable = var.firewall;
  };
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  ## Device dection
  services.libinput = {
    enable = true;
  };

  ## SSD partition cleanup
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  ## Printing
  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        gutenprint
        gutenprintBin
        splix
        hplip
      ];
    };
    ipp-usb.enable = true;
  };

  ## Avahi Dns services
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  ## Location
  location.provider = "geoclue2";

}
