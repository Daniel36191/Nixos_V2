{
  ...
}:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraUpFlags = [
      "--advertise-exit-node"
    ];
    authKeyFile = ../../extra-files/tailscale.key;
  };
}
