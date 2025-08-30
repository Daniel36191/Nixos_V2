{
    pkgs,
    pkgs-stable,
    inputs,
    ...
}:
{
    environment.systemPackages = with pkgs; [
        obs-studio
        v4l-utils ## Obs virtual cam
        # inputs.blender-cuda.packages.${pkgs.system}.default
        # gimp ## Image editing
        pinta ## Image editing
        losslesscut-bin # # video editor
        # prusa-slicer
        orca-slicer ## Crashes on opening webgui
        # freecad-wayland
        # handbrake # # video parser ## fails to build
        soundconverter # # gnome sound transcoder
        yt-dlg ## yt dl

        ## VRC Creator
        pkgs-stable.unityhub
        alcom ## vrc-get gui
    ];
    services.flatpak = {
        packages = [
            "org.gimp.GIMP"
            "io.github.nate_xyz.Paleta"
            "com.prusa3d.PrusaSlicer"
            "fr.handbrake.ghb"
            "org.vinegarhq.Vinegar" ## roblox editor
        ];
    };

    boot = {
    ## This is for OBS Virtual Cam Support ## broken due to lack of vmlinux avalbility
    # kernelModules = [ "v4l2loopback" ];
    # extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    };

    ## Adb
    programs.adb.enable = true;
}