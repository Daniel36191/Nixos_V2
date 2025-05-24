{
  pkgs,
  ...
}:
{

  environment = {
    shells = with pkgs; [
      bashInteractive
      fish
    ];



    #############
    ## Aliases ##
    #############
    shellAliases = {
    vnc = "hyprctl output create headless VNC-1 && wayvnc -o VNC-1 192.168.8.194";
    sudonix = "sudo nixos-rebuild switch --flake .#default";
    updatenix = "sudo nix flake update && sudo nixos-rebuild switch --flake .#default --upgrade-all";
    mi = "micro";

    ## Alterntives
    cat = "bat";
    ls = "eza --icons";
    ll = "eza -lh --icons --grid --group-directories-first";
    la = "eza -lah --icons --grid --group-directories-first";
  };


  ###############
  ## ShellInit ##
  ###############

  shellInit = ''
    fastfetch
  '';



};
}
