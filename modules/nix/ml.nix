{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  mod = config.mod.ml;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [
      llmfit
      python314Packages.huggingface-hub
      python314Packages.hf-transfer
    ];

    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      host = "0.0.0.0";
      openFirewall = true;
    };

    # services.llama-cpp = {
    #   enable = true;
    #   package = pkgs-stable.llama-cpp.override { cudaSupport = true; };
    #   port = 11568;
    #   host = "0.0.0.0";
    # };
  };
}
