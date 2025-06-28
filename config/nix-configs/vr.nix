{
  pkgs,
  inputs,
  ...
}:
{
environment.systemPackages = with pkgs; [
  monado-vulkan-layers
  # monado
  # wlx-overlay-s ## To See Monitor ## Old version
  # wayvr-dashboard ## App Launcher ## Old version
  opencomposite ## Translation Layer


  inputs.lemonake.packages.${pkgs.system}.wlx-overlay-s
  inputs.lemonake.packages.${pkgs.system}.adgobye ## Vrc Adblocker
  inputs.lemonake.packages.${pkgs.system}.wayvr-dashboard

  ## Resolute, Resonite Mod Manager ## Does not work
  # (pkgs.appimageTools.wrapType2 {
  #   name = "resolute";
  #   pname = "resolute";
  #   version = "0.8.3";
  #   src = pkgs.fetchurl {
  #     url = "https://github.com/Gawdl3y/Resolute/releases/download/v0.8.3/resolute_0.8.3_amd64.AppImage";
  #     sha256 = "f41Cm3k+FvNPBSVc9qphF3r9Os5FOKK//bqH/fIukhY="; # replace with actual hash
  #   };
  #   extraPkgs = pkgs: with pkgs; [ libglvnd ];
  #   # Add desktop file generation
  #   extraInstallCommands = ''
  #     mkdir -p $out/share/applications
  #     cat > $out/share/applications/resolute.desktop <<EOF
  #     [Desktop Entry]
  #     Name=Resolute
  #     Exec=resolute
  #     Icon=resolute
  #     Type=Application
  #     Categories=Development;
  #     EOF
  #   '';
  # })

];

##############
## Envision ## Should just work // Eh
##############
# programs.envision = {
#   enable = true;
#   openFirewall = true;
# };


############
## Monado ##
############

services.monado = {
  enable = true;
  defaultRuntime = false; # Register as default OpenXR runtime
};
systemd.user.services.monado.environment = {
  STEAMVR_LH_ENABLE = "1";
  XRT_COMPOSITOR_COMPUTE = "1";
};


###########
## WiVRn ## Wireless
###########

services.wivrn = {
  enable = true;
  autoStart = true;
  defaultRuntime = true;
  openFirewall = true;
  package = (inputs.lemonake.packages.${pkgs.system}.wivrn.override {
    cudaSupport = true; });

  ## Old version
  # package =
  #   (pkgs.wivrn.override {
  #     cudaSupport = true;
  #   });

  # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
  # config = {
  #   enable = true;
  #   json = {
  #     # 1.0x foveation scaling
  #     scale = 1.0;
  #     # 100 Mb/s
  #     bitrate = 100000000;
  #     encoders = [
  #       {
  #         encoder = "vaapi";
  #         codec = "h265";
  #         # 1.0 x 1.0 scaling
  #         width = 1.0;
  #         height = 1.0;
  #         offset_x = 0.0;
  #         offset_y = 0.0;
  #       }
  #     ];
  #   };
  # };
  #
  #  ## to be made into nix code this is correct config
  # {
  #   "application": [
  #     "/run/current-system/sw/bin/wlx-overlay-s"
  #   ],
  #   "bitrate": 100000000,
  #   "encoders": [
  #     {
  #       "encoder": "nvenc",
  #       "height": 1.0,
  #       "offset_x": 0.0,
  #       "offset_y": 0.0,
  #       "width": 0.5
  #     },
  #     {
  #       "encoder": "nvenc",
  #       "height": 1.0,
  #       "offset_x": 0.5,
  #       "offset_y": 0.0,
  #       "width": 0.5
  #     }
  #   ]
  # }
};

## To deal with flatpak steam
services.flatpak.overrides = {
  "com.valvesoftware.Steam".Context = {
    filesystems = [
      ## For Wivrn to work
      "xdg-run/wivrn:ro"
      "xdg-data/flatpak/app/io.github.wivrn.wivrn:ro"
      "xdg-config/openxr:ro"
      "xdg-config/openvr:ro"
    ];
  };
};
system.activationScripts.steamflatpak-openxr = ''
    mkdir -p ~/.var/app/com.valvesoftware.Steam/.config/openxr
    ln -sf ~/.config/openxr/1 ~/.var/app/com.valvesoftware.Steam/.config/openxr/1
  '';

}
