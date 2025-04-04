{
  config,
  pkgs,
  host,
  username,
  options,
  inputs,
  lib,
  ...
}:

#Custom SendMidi
let
  sendmidi = import (pkgs.fetchFromGitHub {
    owner = "dmoeller131";
    repo = "SendMIDI";
    rev = "main"; # Replace with a specific tag or commit hash
    sha256 = "BIl2KON5I5hDWZJb0wrm25lCuX+/zJF/34SKnUrvcqU="; # Replace with the actual hash
  }) {
    inherit (pkgs) stdenv lib fetchFromGitHub alsa-lib pkg-config; # Pass all required arguments
  };
in

{
imports = [
  inputs.spicetify-nix.nixosModules.default
];

environment.systemPackages = with pkgs; [
  spotify
  spicetify-cli
  sendmidi
  pulseaudioFull
  qpwgraph
  bespokesynth
  rnnoise-plugin
  # lsp-plugins ## A lot of plugins
  speech-denoiser ## rnnoise
  cardinal ## Custom .desktop file in desktop-files.nix
];


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
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  enable = true;

  enabledExtensions = with spicePkgs.extensions; [
    shuffle # shuffle+ (special characters are sanitized out of extension names)
    adblock
    # hidepodcasts
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
