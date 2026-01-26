{
  pkgs,
  inputs,
  # pkgs-stable,
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
    # bespokesynth
    bespokesynth
    # chataigne
    sendmidi
    receivemidi
    qpwgraph
    pulseaudioFull
    pavucontrol
    vlc

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

  


  ##################
  ## Audio Routes ##    Not working can't get systemd service to run them properly
  ##################

  # systemd.user.services.loadAudioModules = {
  #   description = "Load custom PulseAudio modules";
  #   requisite = ["pulseaudio.service"];
  #   wantedBy = ["pulseaudio.service"];
  # 
  #   script = "
  #     ## Main Output/Volume\n
  #     exec-once = pactl load-module module-null-sink media.class=Audio/Sink sink_name=Main-Output channels=2\n
  #     \n
  #     ## Sptoify\n
  #     exec-once = pactl load-module module-null-sink media.class=Audio/Sink sink_name=Spotify-Input channels=2\n
  #     ## Volume\n
  #     exec-once = pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Spotify-Volume channels=2\n
  #     \n
  #     ## Mic/Volume\n
  #     exec-once = pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Mic-Output channels=1\n
  #     \n
  #     ## Discord\n
  #     exec-once = pactl load-module module-null-sink media.class=Audio/Sink sink_name=Discord-Output channels=2\n
  #     ## Volume\n
  #     exec-once = pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Discord-Volume channels=2      \n
  #   ";
  # };
}
