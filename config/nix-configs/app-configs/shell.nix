{
  pkgs,
  username,
  ...
}:
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
      windows = "bash --norc ( trap 'hyprctl reload;' INT
          hyprctl keyword monitor \"DP-1, disable\" && lan-mouse -f cli )";
      agenixedit = "sudo EDITOR=$EDITOR agenix --identity /etc/ssh/ssh_host_ed25519_key -e";
      hyprpicker = "hyprpicker -a";

      sudonix = "nh os switch -H $NIX_HOST ./";
      updatenix = "nh os switch -H $NIX_HOST ./ --update";
      updateinput = "nh os switch -H $NIX_HOST ./ --update-input";
      cleannix = "flatpak uninstall --unused && sudo nix-collect-garbage -d";


      ## Alterntives
      mi = "${pkgs.micro}/bin/micro";
      cat = "bat";
      ls = "eza --icons";
      tree = "eza --icons -T";
      ll = "eza -lh --icons --grid --group-directories-first";
      la = "eza -lah --icons --grid --group-directories-first";


      ## Compatibility
      mesalaunch = "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
      browser = "${pkgs.librewolf}/bin/librewolf";
    };

    ###############
    ## ShellInit ##
    ###############

    shellInit = ''
      NIX_HOST
    '';

  };
}
