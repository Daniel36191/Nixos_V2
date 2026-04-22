{
  pkgs,
  inputs,
  lib,
  pkgs-spotifyPin,
  pkgs-personoal,
  ...
}:
let
  sendmidi = pkgs.callPackage ../../custom-apps/send-midi.nix { };
  receivemidi = pkgs.callPackage ../../custom-apps/receive-midi.nix { };
  bespokesynth = pkgs.callPackage ../../custom-apps/bespoke-synth/package.nix { };
  chataigne = pkgs.callPackage ../../custom-apps/chataigne/chataigne.nix { };
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    bespokesynth
    # pkgs-personoal.bespoke-synth
    # chataigne
    sendmidi
    receivemidi
    qpwgraph
    pulseaudioFull
    pavucontrol
    vlc
    # pkgs-personoal.audio-man


    ## Plugins
    rnnoise-plugin
    # lsp-plugins ## A lot of plugins
    speech-denoiser ## rnnoise
    cardinal ## Custom .desktop file in desktop-files.nix
    # rPackages.sparta
  ];

  services.flatpak = {
    packages = [
      # "io.github.Soundux"
    ];
  };

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

  ###############
  ## Spicetify ##
  ###############
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in
    {
      enable = true;
      spotifyPackage = pkgs-spotifyPin.spotify;

      enabledExtensions = with spicePkgs.extensions; [
        shuffle ## shuffle+ (special characters are sanitized out of extension names)
        adblock
        hidePodcasts
        bookmark
        trashbin
        powerBar
        playNext ## Add to queue
        # addToQueueTop  ## Also add to queue

        ## Not working as of this time builds but no output
        #   ({
        #     src = pkgs.fetchFromGitHub {
        #       owner = "adufr";
        #       repo = "spicetify-extensions";
        #       rev = "develop";
        #       hash = "sha256-YSGwhfvINQW3BPRBruV5/Nrmba4zfvNbctxymV/3NRw=";
        #     };
        #     name = "quick-add-to-playlist/dist/quick-add-to-playlist.js";
        # })
        #   # quickaddtoplaylist
        #   # quickaddtoqueue

      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
      ];
      enabledSnippets = with spicePkgs.snippets; [
        pointer
        oneko
      ];
      theme = lib.mkDefault spicePkgs.themes.comfy;
    };

  #############
  ## Bespoke ##
  #############
  services.pipewire.extraConfig.pipewire = {
    "91-bespokesynth" = {
      "node.rules" = [
        {
          matches = [
            { "node.name" = "alsa_playback..BespokeSynth-wrapped"; }
            { "node.name" = "alsa_capture..BespokeSynth-wrapped"; }
          ];
          actions = {
            update-props = {
              "stream.dont-remix" = true;
              "node.autoconnect"= false;
              "node.dont-reconnect" = true;
            };
          };
        }
      ];
    };

    "91-cava" = {
      "node.rules" = [
        {
          matches = [
            { "node.name" = "cava"; }
          ];
          actions = {
            update-props = {
              "stream.dont-remix" = true;
              "node.autoconnect"= false;
              "node.dont-reconnect" = true;
            };
          };
        }
      ];
    };
  };

  ##################
  ## Audio Routes ##
  ##################
  services.pipewire.extraConfig.pipewire."10-virtual-audio" = let
    virtualDevices = [      
      ## General
      { name = "General-Input"; channels = 2; type = "sink"; }
      { name = "General-Volume"; channels = 2; type = "source"; volume = true; }

      ## Mic
      { name = "Mic-Output"; channels = 1; type = "source"; volume = true; }

      ## Spotify
      { name = "Spotify-Input"; channels = 2; type = "sink"; }
      { name = "Spotify-Volume"; channels = 2; type = "source"; volume = true; }
      
      ## Comms
      { name = "Comms-Output"; channels = 2; type = "sink"; }
      { name = "Comms-Volume"; channels = 2; type = "source"; volume = true; }
    ];

    sinkTemplate = {
      factory = "adapter";
      args = {
        "factory.name" = "support.null-audio-sink";
        "media.class" = "Audio/Sink";
      };
    };

    sourceTemplate = {
      factory = "adapter";
      args = {
        "factory.name" = "support.null-audio-sink";
        "media.class" = "Audio/Source/Virtual";
      };
    };

    mapDevice = device: let
        baseTemplate = if device.type == "source" then sourceTemplate else sinkTemplate;
        volumeArgs = if device.volume or false then {
          "monitor.channel-volumes" = true;
        } else {};
      in baseTemplate // {
        args = baseTemplate.args // {
          "object.linger" = true;
          "node.name" = device.name;
          "node.description" = device.name;
          "audio.channels" = device.channels;
        } // volumeArgs;
      };

    mappedConfig = lib.lists.forEach virtualDevices mapDevice;

  in {
    "context.objects" = mappedConfig;
  };
}
