{
  config,
  lib,
  pkgs-stable,
  ...
}:
{
  ############
  ## Nvidia ##
  ############

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia-container-toolkit.enable = true; # # For Containers to use gpu
  hardware.nvidia = {
    modesetting.enable = true;
    forceFullCompositionPipeline = false;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = true;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "575.64.05";
    #   sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
    #   sha256_aarch64 = lib.fakeHash; #"sha256-7XswQwW1iFP4ji5mbRQ6PVEhD4SGWpjUJe1o8zoXYRE=";
    #   openSha256 = "sha256-hEAmFISMuXm8tbsrB+WiUcEFuSGRNZ37aKWvf0WJ2/c=";
    #   settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M=";
    #  persistencedSha256 = lib.fakeHash; #"sha256-XaPN8jVTjdag9frLPgBtqvO/goB5zxeGzaTU0CdL6C4=";
    # };
  };

  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
