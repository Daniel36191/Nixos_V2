{
  pkgs,
  ...
}:
{
  #############
  ## Backend ##
  #############
  services.pipewire = {
    enable = true;
    package = pkgs.pipewire;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig = {
    };

    wireplumber = {
      enable = true;
      extraConfig = {
        ## Take Calls On Pc (HFP)
        "monitor.bluez.properties" = {
          bluez5.roles = [ "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" "hsp_hs" ];
          bluez5.enable-msbc = true;
          bluez5.hfphsp-backend = "native";
        };
      };
    };
  };
  boot = {
    kernelModules = [ "snd-seq-dummy" ]; ## Alsa Midi-Through-Port-0
  };

  # Enable sound with pulse
  services.pulseaudio.enable = false;
}