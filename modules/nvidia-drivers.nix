{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.nvidia;
in
{
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {


##########
# Nvidia #
##########

hardware.graphics = {
  enable = true;
};
services.xserver.videoDrivers = ["nvidia"];

hardware.nvidia = {
  modesetting.enable = true;
  powerManagement = {
    enable = false;
    finegrained = false;
  };
  open = false;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.latest;
  # package = config.boot.kernelPackages.nvidiaPackages.beta;
  # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #   version = "555.58";
  #   sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";
  #   sha256_aarch64 = "sha256-7XswQwW1iFP4ji5mbRQ6PVEhD4SGWpjUJe1o8zoXYRE=";
  #   openSha256 = "sha256-hEAmFISMuXm8tbsrB+WiUcEFuSGRNZ37aKWvf0WJ2/c=";
  #   settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M="; #"sha256-m2rNASJp0i0Ez2OuqL+JpgEF0Yd8sYVCyrOoo/ln2a4=";
  #   persistencedSha256 = lib.fakeHash; #"sha256-XaPN8jVTjdag9frLPgBtqvO/goB5zxeGzaTU0CdL6C4=";
  # };
};
};
}