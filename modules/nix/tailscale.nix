{
  config,
  lib,
  var,
  ...
}:
let
  mod = config.mod.nix.tailscale;
in
{
  config = lib.mkIf mod.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
      extraUpFlags = [
        # "--advertise-exit-node"
        # "--accept-routes"
        # "--exit-node 100.100.57.77"
        # "--auth-key file:${config.age.secrets."tailscale-${nix-host}".path}"
        "--reset"
      ];
      extraSetFlags = [
        "--operator=${config.mod.username}"
      ];
      authKeyFile = config.age.secrets."tailscale-${var.host}".path;
    };

    ## For Exit Node
    # boot.kernel.sysctl = {
    #   "net.ipv4.ip_forward" = 1;
    #   "net.ipv6.conf.all.forwarding" = 1;
    # };

    ## Use nftables for tailscale
    networking.nftables.enable = lib.mkDefault true;
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      # Allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
