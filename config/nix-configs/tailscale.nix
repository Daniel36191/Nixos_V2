{
  config,
  nix-host,
  pkgs,
  ...
}:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraUpFlags = [
      "--advertise-exit-node"
      # "--accept-routes"
      # "--auth-key=file:${config.age.secrets."tailscale-${nix-host}".path}"
      "--reset"
    ];
    authKeyFile = config.age.secrets."tailscale-${nix-host}".path;
  };
# 
# 
#     services = {
#     networkd-dispatcher = {
#       enable = true;
#       rules."50-tailscale" = {
#         onState = ["routable"];
#         script = ''
#           ${pkgs.ethtool}/bin/ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off
#         '';
#       };
#     };
#   };

  # CRITICAL: Enable IP forwarding for exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

#   services.tailscale = {
#     enable = true;
#     openFirewall = true;
#     useRoutingFeatures = "server";  # Enable server features
#     extraUpFlags = [
#       "--advertise-exit-node"
#       "--accept-routes"
#       # Remove --reset flag
#     ];
#     authKeyFile = config.age.secrets."tailscale-${nix-host}".path;
#   };
# 
#   # Proper networkd-dispatcher configuration
#   services.networkd-dispatcher = {
#     enable = true;
#     rules."50-tailscale" = {
#       onState = ["routable"];
#       script = ''
#         # Match your actual interface name (check with `ip link show`)
#         if [ "$IFACE" = "enp5s0" ]; then
#           ${pkgs.ethtool}/bin/ethtool -K "$IFACE" rx-udp-gro-forwarding on rx-gro-list off
#         fi
#       '';
#     };
#   };
# 
#   # Additional firewall configuration for exit node
#   networking.firewall = {
#     checkReversePath = "loose";  # Important for exit nodes
#     allowedUDPPorts = [ 41641 ]; # Tailscale UDP port
#     trustedInterfaces = [ "tailscale0" ];
#     
#     # Allow traffic from tailscale0 to forward
#     extraCommands = ''
#       iptables -A FORWARD -i tailscale0 -j ACCEPT
#       iptables -A FORWARD -o tailscale0 -j ACCEPT
#       ip6tables -A FORWARD -i tailscale0 -j ACCEPT
#       ip6tables -A FORWARD -o tailscale0 -j ACCEPT
#     '';
#     
#     extraStopCommands = ''
#       iptables -D FORWARD -i tailscale0 -j ACCEPT 2>/dev/null || true
#       iptables -D FORWARD -o tailscale0 -j ACCEPT 2>/dev/null || true
#       ip6tables -D FORWARD -i tailscale0 -j ACCEPT 2>/dev/null || true
#       ip6tables -D FORWARD -o tailscale0 -j ACCEPT 2>/dev/null || true
#     '';
#   };
}
