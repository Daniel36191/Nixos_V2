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
    shell = pkgs.fish; # # pkgs.bash is default
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
      windows = "bash --norc ( trap 'hyprctl reload;' INT
          hyprctl keyword monitor \"DP-1, disable\" && lan-mouse -f cli )";
      # sudonix = "sudo nixos-rebuild switch --flake .#default";
      # updatenix = "sudo nix flake update && sudo nixos-rebuild switch --flake .#default --upgrade-all";
      sudonix-pc = "nh os switch -H pc ./";
      updatenix-pc = "nh os switch -H pc ./ --update";
      updateinput-pc = "nh os switch -H pc ./ --update-input";
      sudonix-laptop = "nh os switch -H laptop ./";
      updatenix-laptop = "nh os switch -H laptop ./ --update";
      updateinput-laptop = "nh os switch -H laptop ./ --update-input";
      cleannix = "flatpak uninstall --unused && sudo nix-collect-garbage -d";
      mi = "micro";
      mesalaunch = "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";

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
