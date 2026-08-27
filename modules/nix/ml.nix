{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.ml;
  conf = config.mod;
  pkg =
    if conf.nvidia-drivers.enable then
      pkgs.ollama-cuda
    else if conf.amd-drivers.enable then
      pkgs.ollama-rocm
    else
      pkgs.ollama-vulkan;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with unstable; [
      llmfit
      python314Packages.huggingface-hub
      python314Packages.hf-transfer
    ];

    services.ollama = {
      enable = true;
      package = pkg;
      host = "0.0.0.0";
      openFirewall = true;
    };
  };
}
