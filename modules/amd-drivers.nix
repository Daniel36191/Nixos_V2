{
  pkgs,
  ...
}:
{
    hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  systemd.tmpfiles.rules = [ ## HIP Work around for hard coded libs
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}