{
  pkgs,
  ...
}:
let
  inherit (import ../../variables.nix)
  username
  ;
in
{

users.users."${username}" = {
    shell = pkgs.fish; ## pkgs.bash is default
    ignoreShellProgramCheck = true;
};

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
    cleannix = "flatpak uninstall --unused && sudo nix-collect-garbage -d";
    mi = "micro";

    ## Alterntives
    cat = "bat";
    ls = "eza --icons";
    ll = "eza -lh --icons --grid --group-directories-first";
    la = "eza -lah --icons --grid --group-directories-first";
    # grep = "rg"; ## not great
    find = "fd";
  };


  ###############
  ## ShellInit ##
  ###############

  shellInit = ''
    fastfetch
  '';



};
}
