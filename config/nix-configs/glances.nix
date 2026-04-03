{
  username,
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
      "/home/${username}/.config/glances/glances.conf"
      ];
  };
}