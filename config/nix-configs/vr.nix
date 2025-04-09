{ config, pkgs, ... }:


{
environment.systemPackages = with pkgs; [
  monado-vulkan-layers
  # monado
  wlx-overlay-s # To See Monitor
  wayvr-dashboard # App Launcher
  opencomposite # Translation Layer


  ## Resolute, Resonite Mod Manager
  (pkgs.appimageTools.wrapType2 {
    name = "resolute";
    pname = "resolute";
    version = "0.8.3";
    src = pkgs.fetchurl {
      url = "https://github.com/Gawdl3y/Resolute/releases/download/v0.8.3/resolute_0.8.3_amd64.AppImage";
      sha256 = "f41Cm3k+FvNPBSVc9qphF3r9Os5FOKK//bqH/fIukhY="; # replace with actual hash
    };
    extraPkgs = pkgs: with pkgs; [ libglvnd ];
    # Add desktop file generation
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/resolute.desktop <<EOF
      [Desktop Entry]
      Name=Resolute
      Exec=resolute
      Icon=resolute
      Type=Application
      Categories=Development;
      EOF
    '';
  })

];

##############
## Envision ## Should just work
##############
programs.envision = {
  enable = true;
  openFirewall = true;
};


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
  openFirewall = true;
  package =
    (pkgs.wivrn.override {
      cudaSupport = true;
    });

  # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
  # will automatically read this and work with WiVRn (Note: This does not currently
  # apply for games run in Valve's Proton)
    defaultRuntime = true;

  # Run WiVRn as a systemd service on startup
  autoStart = false;

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
};

}
