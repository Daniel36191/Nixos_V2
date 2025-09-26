{
  config,
  nix-host,
  ...
}:
let
  tailscale-key = "tailscale-${nix-host}";
in
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraUpFlags = [
      "--advertise-exit-node"
    ];
    authKeyFile = config.age.secrets.${tailscale-key}.path;
  };
}
