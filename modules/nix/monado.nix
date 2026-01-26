{
  pkgs,
  ...
}:
{
  services.monado = {
    enable = true;
    package = pkgs.monado;
    defaultRuntime = false; ## Register as default OpenXR runtime
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };
}