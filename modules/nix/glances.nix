{
  config,
  ...
}:
let
in
{
  services.glances = {
    enable = true;
    openFirewall = true;
    port = 61208;
    extraArgs = [
      "--webserver"
      "-C"
      "/home/${config.mod.username}/.config/glances/glances.conf"
    ];
  };
}
