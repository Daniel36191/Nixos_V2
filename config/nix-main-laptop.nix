{
  ...
}:
{
  ## Temporary this is from gnome
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];
  imports = [
    ## Apps
    ./nix-configs/vm.nix
    # ./nix-configs/containers.nix
    # ./nix-configs/vr.nix
    ./nix-configs/apps.nix
    # ./nix-configs/samba.nix
    # ./nix-configs/tailscale.nix ##Encript with sops nix
    ./nix-configs/games.nix
    ./nix-configs/creative.nix
    ./nix-configs/coding.nix
    # ./nix-configs/apps-pc.nix
    ./nix-configs/apps-laptop.nix
    # ./nix-configs/zerotier.nix
    ./nix-configs/office.nix
    ./nix-configs/syncthing.nix
    ./nix-configs/brightness.nix

    ## App Configs
    ./nix-configs/app-configs/starship.nix
    ./nix-configs/app-configs/fish.nix
    ./nix-configs/app-configs/shell.nix ## fix the cleannix command to use nh

    ## Theme
    ./nix-configs/theme.nix ##blacklist libreofficr from stylix
    ./nix-configs/sound.nix
    ./nix-configs/wm-modules/hyprland.nix

    ## Core
    ./nix-main.nix
    ./nix-configs/users.nix
    ./nix-configs/defaults.nix
    ./nix-configs/core/devices.nix
    ./nix-configs/core/boot.nix
    ./nix-configs/core/core-services.nix

    ## To Be Cleaned
    # ../modules/nvidia-drivers.nix

    ## No Touch
    ./nix-configs/core/hardware-laptop.nix
  ];

  ####################
  ## Profile Config ##
  ####################
    environment.shellAliases = {
      NIX_HOST = "export NIX_HOST=laptop";
    };


  ##############
  ## hardware ##
  ##############

  services.fwupd.enable = true;

}
