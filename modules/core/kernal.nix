{
  pkgs,
  config,
  ...
}:
let
in
{
  boot = {
    ## Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    extraModulePackages = with config.boot.kernelPackages; [ ];
    kernelModules = [ "snd-seq-dummy" ];
    kernel.sysctl = {
      "kernel.task_delayacct" = 1;
    };
  };
}
