{
  pkgs,
  hostname,
  firewall,
  ...
}:
{
  ## Networking
  networking = {
    networkmanager.enable = true;
    hostName = hostname;

    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    firewall.enable = firewall;
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
      drivers = [
      ];
    };
    ipp-usb.enable = true;
  };

  ## Avahi Dns services
  services = {
    avahi = {
      enable = true;
      # nssmdns4 = true;
      openFirewall = true;
    };
  };

  ## Location
  location.provider = "geoclue2";

}
