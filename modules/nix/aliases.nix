{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.aliases;
in
{
  config = lib.mkIf mod.enable {
    environment.shellAliases = {
      vnc = "hyprctl output create headless VNC-1 && wayvnc -o VNC-1 192.168.8.194";
      windows = "bash --norc ( trap 'hyprctl reload;' INT
          hyprctl keyword monitor \"DP-1, disable\" && lan-mouse -f cli )";
      agenixedit = "sudo EDITOR=$EDITOR agenix --identity /etc/ssh/ssh_host_ed25519_key -e";
      hyprpicker = "${pkgs.hyprpicker} -a";

      sudonix = "sudo -v && ${pkgs.nh}/bin/nh os switch -H $NIX_HOST ~/Nixos_V2";
      updatenix = "sudo -v && ${pkgs.nh}/bin/nh os switch -H $NIX_HOST ./ --update";
      updateinput = "sudo -v && flatpak update && nh os switch -H $NIX_HOST ./ --update-input";
      cleannix = "sudo -v && flatpak uninstall --unused && sudo nix-collect-garbage -d";

      ## Alterntives
      mi = "${pkgs.micro}/bin/micro";
      cat = "${pkgs.bat}/bin/bat";
      grep = "${pkgs.ripgrep}/bin/rg";
      df = "${pkgs.dysk}/bin/dysk";
      sleep = "${pkgs.timer}/bin/timer";
      vim = "${pkgs.neovim}/bin/nvim";

      ## ls
      ls = "${pkgs.eza}/bin/eza --icons";
      ll = "${pkgs.eza}/bin/eza -lh --icons --grid --group-directories-first";
      la = "${pkgs.eza}/bin/eza -lah --icons --grid --group-directories-first";
      tree = "${pkgs.eza}/bin/eza --icons -T";
      links = "${pkgs.eza}/bin/eza -lh --icons --grid --group-directories-first --hyperlink";

      ## Aliases
      size = "du -sh";
      img2text = "${pkgs.tesseract}/bin/tesseract stdin stdout";
      log = "journalctl -xef -u";
      logs = "journalctl -xe -u";
      scrcpy = "${pkgs.scrcpy}/bin/scrcpy --video-codec=h264 
        --video-encoder=OMX.google.h264.encoder --render-driver=opengl";
      stopwatch = "${pkgs.clock-rs}/bin/clock-rs stopwatch";
      olaplay = "${pkgs.mpv}/bin/mpv --audio-channels=stereo --ad-lavc-downmix=yes";

      ## Compatibility
      mesalaunch = "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
      browser = "${pkgs.librewolf}/bin/librewolf";
    };
  };
}
