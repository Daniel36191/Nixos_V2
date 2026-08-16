{
  config,
  lib,
  pkgs,
  inputs,
  pkgs-stable,
  pkgs-personal,
  pkgs-unstable,
  ...
}:
let
  mod = config.mod.creative;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [
      obs-studio
      v4l-utils # Obs virtual cam
      # inputs.blender-cuda.packages.${pkgs.stdenv.hostPlatform.system}.default
      # gimp
      pinta
      krita
      losslesscut-bin
      # prusa-slicer
      # orca-slicer ## Crashes on opening webgui
      # pkgs-personal.orca-beta
      pkgs-unstable.freecad
      # kicad ## Broken link for symbols
      # handbrake ## video parser ## fails to build
      soundconverter
      yt-dlg
      godot
      android-tools

      # Older editor versions do not support OpenSSL 3.
      # Fix for infinite project importing: https://discussions.unity.com/t/linux-editor-stuck-on-loading-because-of-bee-backend-w-workaround/854480
      (pkgs.unityhub.override {
        extraLibs =
          pkgs: with pkgs; [
            openssl_1_1
          ];
      })
      ## VCC
      alcom
    ];
    services.flatpak = {
      packages = [
        "org.gimp.GIMP"
        "com.orcaslicer.OrcaSlicer"
        "io.github.nate_xyz.Paleta"
        "com.prusa3d.PrusaSlicer"
        "fr.handbrake.ghb"
        "org.vinegarhq.Vinegar"
        "org.kicad.KiCad"
      ];
    };

    boot = {
      ## This is for OBS Virtual Cam Support ## broken due to lack of vmlinux avalbility
      kernelModules = [ "v4l2loopback" ];
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1
      '';
    };
  };
}
