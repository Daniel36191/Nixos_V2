{
  pkgs,
  ...
}:
let
  inherit (import ../../variables.nix)
  hostName
  firewall
  ;
in
{
  ## Networking
  networking = {
  networkmanager.enable = true;
  hostName = "${hostName}";

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

  ## Gnome virtual file system
  services = {
    gvfs.enable = true;
  };

  ## Printing
  services = {
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
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

}
