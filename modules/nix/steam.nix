{
  pkgs,
  inputs,
  ...
}:
{
  ###########
  ## Steam ##
  ###########
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
    extest.enable = true; ## For wayland and controlers
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = false;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true; ## Defaults mangohud on for every game
        OBS_VKCAPTURE = true;
        RADV_TEX_ANISO = 16;
      };
      extraLibraries =
        p: with p; [
          atk
        ];
    };
    extraPackages = with pkgs; [
      gamescope
      mangohud
      gamemode
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      inputs.lemonake.packages.${pkgs.system}.proton-ge-rtsp ## for VRC
      steamtinkerlaunch
      # proton-vkvr
    ];
  };
   boot = {
    ## Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
   };
}