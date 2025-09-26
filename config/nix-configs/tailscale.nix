{
  config,
  nix-host,
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
    authKeyFile = config.age.secrets."tailscale-${nix-host}".path;
  };
}
