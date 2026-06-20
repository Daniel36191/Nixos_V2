{
  pkgs,
  pkgs-spotifyPin,
  lib,
  inputs,
  config,
  ...
}:
let
  mod = config.mod.spotify;
in
{
  config = lib.mkIf mod.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
      in
      {
        enable = true;
        spotifyPackage = pkgs-spotifyPin.spotify;

        enabledExtensions = with spicePkgs.extensions; [
          shuffle # shuffle+ (special characters are sanitized out of extension names)
          adblock
          hidePodcasts
          powerBar
          playNext # Add to queue
          allOfArtist # auto makes playlist of all artist's songs
          aiBandBlocker # This is just sad
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
  };
}
