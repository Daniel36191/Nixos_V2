{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.btop;
in
{
  config = lib.mkIf mod.enable {
    programs = {
      btop = {
        enable = true;
        package = pkgs.btop.override {
          rocmSupport = true;
          cudaSupport = true;
        };
        settings = {
          rounded_corners = true;
          show_gpu_info = "on";
          show_uptime = true;
          show_coretemp = true;
          cpu_sensor = "auto";
          show_disks = true;
          only_physical = true;
          io_mode = true;
          io_graph_combined = false;
        };
      };
    };
  };
}
