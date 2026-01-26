{
  inputs,
  pkgs,
  lib,
  pkgs-spotifyPin,
  ...
}:
{
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
}