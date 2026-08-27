{
  config,
  lib,
  pkgs,
  inputs,
  pkgs-personal,
  var,
  ...
}:
let
  mod = config.mod.sound;
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];
  config = lib.mkIf mod.enable {

    environment.systemPackages = with unstable; [
      # bespokesynth
      pkgs-personal.bespoke-synth
      # pkgs-personal.chataigne
      pkgs-personal.send-midi
      pkgs-personal.receive-midi
      qpwgraph
      pulseaudioFull
      pavucontrol
      vlc
      pkgs-personal.audio-man
      spotify-player

      ## Plugins
      rnnoise-plugin
      # lsp-plugins # A lot of plugins
      speech-denoiser # rnnoise
      cardinal # Custom .desktop file in desktop-files.nix
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
        pipewire = {
          "00-allowed-rates" = {
            "context.properties" = {
              "default.clock.allowed-rates" = [
                44100
                48000
                96000
              ];
            };
          };
        };
      };

      wireplumber = {
        enable = true;
        extraConfig = {
          "monitor.bluez.properties" = {
            bluez5.roles = [
              "a2dp_sink"
              "a2dp_source"
              "bap_sink"
              "bap_source"
            ];
            bluez5.enable-msbc = false;
            bluez5.hfphsp-backend = "none";
          };
        };
      };
    };
    boot = {
      kernelModules = [ "snd-seq-dummy" ]; # Alsa Midi-Through-Port-0
    };

    # Enable sound with pulse
    services.pulseaudio.enable = false;

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
                "node.autoconnect" = false;
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
                "node.autoconnect" = false;
                "node.dont-reconnect" = true;
              };
            };
          }
        ];
      };
    };
    systemd.user.services.midi-watcher = {
      enable = true;
      wantedBy = [ "default.target" ];
      description = "Midi Watcher";
      serviceConfig = {
        Type = "simple";
        ExecStart =
          let
            midi-watcher = pkgs.writeShellScriptBin "midi-watcher" ''
              ${pkgs-personal.receive-midi}/bin/receivemidi dev "Midi Through Port-0" cc | while IFS= read -r line; do
                if [[ $line =~ control-change[[:space:]]+([0-9]+)[[:space:]]+([0-9]+) ]]; then
                  cc_num="''${BASH_REMATCH[1]}"
                  value="''${BASH_REMATCH[2]}"

                  if (( cc_num >= 10 && cc_num <= 20 )); then
                    echo "$value" > "/tmp/midi_cc''${cc_num}.value"
                  fi
                fi
              done
            '';
          in
          ''
            ${midi-watcher}/bin/midi-watcher
          '';
        Restart = "always";
        RestartSec = "5s";
        User = "${var.username}";
      };
    };

    ##################
    ## Audio Routes ##
    ##################
    services.pipewire.extraConfig.pipewire."10-virtual-audio" =
      let
        virtualDevices = [
          ## General
          {
            name = "General-Input";
            channels = 2;
            type = "sink";
          }
          {
            name = "General-Volume";
            channels = 2;
            type = "source";
            volume = true;
          }

          ## Mic
          {
            name = "Mic-Output";
            channels = 1;
            type = "source";
            volume = true;
          }

          ## Spotify
          {
            name = "Spotify-Input";
            channels = 2;
            type = "sink";
          }
          {
            name = "Spotify-Volume";
            channels = 2;
            type = "source";
            volume = true;
          }

          ## Comms
          {
            name = "Comms-Output";
            channels = 2;
            type = "sink";
          }
          {
            name = "Comms-Volume";
            channels = 2;
            type = "source";
            volume = true;
          }
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

        mapDevice =
          device:
          let
            baseTemplate = if device.type == "source" then sourceTemplate else sinkTemplate;
            volumeArgs =
              if device.volume or false then
                {
                  "monitor.channel-volumes" = true;
                }
              else
                { };
          in
          baseTemplate
          // {
            args =
              baseTemplate.args
              // {
                "object.linger" = true;
                "node.name" = device.name;
                "node.description" = device.name;
                "audio.channels" = device.channels;
              }
              // volumeArgs;
          };

        mappedConfig = lib.lists.forEach virtualDevices mapDevice;

      in
      {
        "context.objects" = mappedConfig;
      };
  };
}
