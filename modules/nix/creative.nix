{
  config,
  lib,
  pkgs,
  inputs,
  pkgs-stable,
  pkgs-personal,
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
      # inputs.blender-cuda.packages.${pkgs.system}.default
      # gimp
      pinta
      krita
      losslesscut-bin
      # prusa-slicer
      # orca-slicer ## Crashes on opening webgui
      # pkgs-personal.orca-beta
      freecad
      # handbrake ## video parser ## fails to build
      soundconverter
      yt-dlg
      godot
      android-tools

      ## VRC Creator
      pkgs-stable.unityhub
      alcom
    ];
    services.flatpak = {
      packages = [
        "org.gimp.GIMP"
        "io.github.nate_xyz.Paleta"
        "com.prusa3d.PrusaSlicer"
        "fr.handbrake.ghb"
        "org.vinegarhq.Vinegar" # roblox editor
      ];
    };

    boot = {
      ## This is for OBS Virtual Cam Support ## broken due to lack of vmlinux avalbility
      # kernelModules = [ "v4l2loopback" ];
      # extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    };
  };
}
