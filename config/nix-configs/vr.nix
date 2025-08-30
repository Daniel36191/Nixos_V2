{
  pkgs,
  inputs,
  pkgs-old,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    monado-vulkan-layers
    # monado
    # wlx-overlay-s ## To See Monitor ## Old version
    # wayvr-dashboard ## App Launcher ## Old version
    opencomposite # # Translation Layer

    inputs.lemonake.packages.${pkgs.system}.wlx-overlay-s
    inputs.lemonake.packages.${pkgs.system}.wayvr-dashboard

    slimevr # # slime vr :)

  ];

  ##############
  ## Envision ## NO, DO NOT USE SEE = https://lvra.gitlab.io/docs/distros/nixos/#envision
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
    package = (
      pkgs-old.wivrn.override {
        cudaSupport = true;
      }
    );

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
