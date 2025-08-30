{
  pkgs,
  inputs,
  lib,
  pkgs-spotifyOld,
  ...
}:

let
  sendmidi = pkgs.callPackage ../../custom-apps/send-midi.nix { };
  receivemidi = pkgs.callPackage ../../custom-apps/receive-midi.nix { };
  bespokesynth = pkgs.callPackage ../../custom-apps/bespoke-synth/package.nix { };
  chataigne = pkgs.callPackage ../../custom-apps/chataigne.nix { };
in

{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    #bespokesynth
    bespokesynth
    # chataigne
    sendmidi
    receivemidi
    qpwgraph
    pulseaudioFull
    pavucontrol

    ## Plugins
    rnnoise-plugin
    # lsp-plugins ## A lot of plugins
    speech-denoiser # # rnnoise
    cardinal # # Custom .desktop file in desktop-files.nix
    # rPackages.sparta
  ];

  services.flatpak = {
  packages = [
    "io.github.Soundux"
  ];
  };

  #############
  ## Backend ##
  #############
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # wireplumber = {
    #   enable = true;
    #   extraConfig = {
    #   };
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
      spotifyPackage = pkgs-spotifyOld.spotify;

      enabledExtensions = with spicePkgs.extensions; [
        shuffle # shuffle+ (special characters are sanitized out of extension names)
        adblock
        hidePodcasts
        bookmark
        trashbin
        powerBar

        # # Not working as of this time builds but no output
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
        # marketplace # Broken
      ];
      enabledSnippets = with spicePkgs.snippets; [
        # # Broken??
        pointer
        oneko
      ];

      theme = lib.mkDefault spicePkgs.themes.comfy;
      # colorScheme = lib.mkDefault "Macchiato";
    };

  ##################
  ## Audio Routes ##    Not working can't get systemd service to run them properly
  ##################

  # systemd.user.services.loadAudioModules = {
  #   description = "Load custom PulseAudio modules";
  #   wants = ["pulseaudio.service"];
  #   script = "
  #     pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=fake-bespoke-source channels=16\n
  #     pactl load-module module-null-sink media.class=Audio/Sink sink_name=fake-bespoke-output channels=16\n
  # \n
  #     pactl load-module module-null-sink media.class=Audio/Sink sink_name=Spotify-Input channels=2\n
  #     pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Mic-Output channels=1\n
  # \n
  #     # pactl load-module module-null-sink media.class=Audio/Sink sink_name=Sonobus-Input channels=2\n
  #     # pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Sonobus-Output channels=1\n
  # \n
  #     pactl load-module module-null-sink media.class=Audio/Sink sink_name=Discord-Input channels=2\n
  #     pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Discord-Output channels=1\n
  # \n
  #     pactl load-module module-null-sink media.class=Audio/Sink sink_name=Main-Input channels=2\n
  #     pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=Sonobus-Output channels=1\n
  #   ";
  # };

}
