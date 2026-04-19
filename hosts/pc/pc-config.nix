{
  lib,
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
  # mod = {
  #   aliases = true;
  #   amd-drivers = true;
  #   amd-framework = true;
  #   apps = true;
  #   bitwarden = true;
  #   boot = true;
  #   borg = true;
  #   brightness = true;
  #   btop = true;
  #   coding = true;
  #   containers = true;
  #   creative = true;
  #   defaults = true;
  #   desktop-files = true;
  #   devices = true;
  #   dms = true;
  #   fastfetch = true;
  #   fish = true;
  #   games = true;
  #   git = true;
  #   glances = true;
  #   hyprland = {
  #     enable = true;
  #     hyprdynamicmonitors = {
  #       monitors = true;
  #     };
  #     hyprlock = true;
  #     hyprpanel = true;
  #     wlogout = true;
  #   };
  #   kernal = true;
  #   kitty = true;
  #   nautilus = true;
  #   noctalia = true;
  #   nvidia-drivers = true;
  #   office = true;
  #   quickshell = true;
  #   qutebrowser = true;
  #   rofi = {
  #     enable = true;
  #     config-emoji = true;
  #     config-long = true;
  #   };
  #   samba = true;
  #   sound = true;
  #   starship = true;
  #   swappy = true;
  #   swaync = true;
  #   syncthing = true;
  #   sys-apps = true;
  #   system-services = true;
  #   tailscale = true;
  #   theme = true;
  #   user-defaults = true;
  #   users = true;
  #   vm = true;
  #   vr = true;
  #   waybar = true;
  #   webapps = true;
  #   zerotier = true;
  #   zoxide = true;
  # };
}
