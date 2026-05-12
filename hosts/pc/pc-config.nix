{
  ...
}:
{
  ############
  ## System ##
  ############
  hostConf = {
    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUbaQCPcnGcg26JmKGXEDUGDywf95UhziIQ7YIXkzYC daniel@nixos-pc";
  };

  #############
  ## Modules ##
  #############
  mod = {
    ##########
    ## Uses ##
    ##########
    coding.enable = true;
    creative.enable = true;
    office.enable = true;
    games.enable = true;
    vr.enable = true;
    containers.enable = false;
    vm.enable = true;

    ##########
    ## Apps ##
    ##########
    apps.enable = true;
    sys-apps.enable = true;
    bitwarden.enable = true;
    git.enable = true;
    swappy.enable = true;
    qutebrowser.enable = true;
    swaync.enable = false;
    nautilus.enable = true;
    syncthing.enable = true;
    spotify.enable = true;

    #########
    ## Cli ##
    #########
    kitty.enable = true;
    glances.enable = false;
    zoxide.enable = true;
    btop.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    starship.enable = true;
    aliases.enable = true;

    #############
    ## Desktop ##
    #############
    hyprland = {
      enable = true;
      hyprdynamicmonitors.enable = true;
      hyprlock.enable = false;
      wlogout.enable = false;
    };
    rofi = {
      enable = true;
      config-emoji.enable = true;
      config-long.enable = true;
    };
    theme.enable = true;

    ############
    ## Shells ##
    ############
    dms.enable = true;
    noctalia.enable = false;
    waybar.enable = false;
    hyprpanel.enable = false;

    ##############
    ## Services ##
    ##############
    tailscale.enable = true;
    zerotier.enable = true;
    borg.enable = false;
    samba.enable = false;

    ###############
    ## Functions ##
    ###############
    desktop-files.enable = true;
    webapps.enable = true;

    ##########
    ## Core ##
    ##########
    boot.enable = true;
    kernal.enable = true;
    devices.enable = true;
    system-services.enable = true;
    sound.enable = true;
    user-defaults.enable = true;
    users.enable = true;
    defaults.enable = true;

    ##############
    ## Hardware ##
    ##############
    brightness.enable = false;
    nvidia-drivers.enable = true;
    amd-framework.enable = false;
    amd-drivers.enable = false;
  };
}
