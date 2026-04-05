{
  pkgs,
  pkgs-unstable,
  config,
  inputs,
  ...
}:
let
in
{
  environment.systemPackages = with pkgs; [
    monado-vulkan-layers
    # monado

    pkgs-unstable.wayvr

    pkgs-unstable.opencomposite ## Translation Layer
    # slimevr ## slime vr :)

    ## Hotas remapping
    input-remapper

  ];

  ############
  ## Monado ##
  ############

  services.monado = {
    enable = true;
    package = pkgs-unstable.monado;
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
    package = pkgs-unstable.wivrn.override { cudaSupport = true; };
    autoStart = true;
    highPriority = true;
    defaultRuntime = true;
    openFirewall = true;
    steam.package = config.programs.steam.package;
    extraServerFlags = [
      "--early-active-runtime"
    ];
    # config.json = {
    #   openvr-compat-path = pkgs.xrizer;
    # };
    # package = wivrn-fixed;
    # package = (
    #   pkgs.wivrn.override {
    #     cudaSupport = true;
    #   }
    # );

  #   # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
  #   # config = {
  #   #   enable = true;
  #   #   json = {
  #   #     # 1.0x foveation scaling
  #   #     scale = 1.0;
  #   #     # 100 Mb/s
  #   #     bitrate = 100000000;
  #   #     encoders = [
  #   #       {
  #   #         encoder = "vaapi";
  #   #         codec = "h265";
  #   #         # 1.0 x 1.0 scaling
  #   #         width = 1.0;
  #   #         height = 1.0;
  #   #         offset_x = 0.0;
  #   #         offset_y = 0.0;
  #   #       }
  #   #     ];
  #   #   };
  #   # };
  #   #
  #   #  ## to be made into nix code this is correct config
  #   # {
  #   #   "application": [
  #   #     "/run/current-system/sw/bin/wlx-overlay-s"
  #   #   ],
  #   #   "bitrate": 100000000,
  #   #   "encoders": [
  #   #     {
  #   #       "encoder": "nvenc",
  #   #       "height": 1.0,
  #   #       "offset_x": 0.0,
  #   #       "offset_y": 0.0,
  #   #       "width": 0.5
  #   #     },
  #   #     {
  #   #       "encoder": "nvenc",
  #   #       "height": 1.0,
  #   #       "offset_x": 0.5,
  #   #       "offset_y": 0.0,
  #   #       "width": 0.5
  #   #     }
  #   #   ]
  #   # }
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
