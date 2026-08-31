{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
let
  mod = config.mod.aliases;

  timer = lib.getExe (
    pkgs.writeShellScriptBin "timer" ''
      ${unstable.clock-rs}/bin/clock-rs -c '#89B4FA' timer -kM "$1" && paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/service-logout.oga
    ''
  );

  sendnix = lib.getExe (
    pkgs.writeShellScriptBin "sendnix" ''
      sudo -v && ${unstable.nh}/bin/nh os switch -H "$1" --log-format bar-with-logs --target-host "$1".local ./
    ''
  );
in
{
  config = lib.mkIf mod.enable {
    environment.shellAliases = with unstable; {
      ## Testing
      vnc = "hyprctl output create headless VNC-1 && wayvnc -o VNC-1 192.168.8.194";
      windows = "bash --norc ( trap 'hyprctl reload;' INT
          hyprctl keyword monitor \"DP-1, disable\" && lan-mouse -f cli )";

      ## Nix
      sudonix = "sudo -v && ${nh}/bin/nh os switch -H $NIX_HOST --keep-going --log-format bar-with-logs ./";
      updatenix = "sudo -v && ${nh}/bin/nh os switch -H $NIX_HOST --keep-going --log-format bar-with-logs ./ --update";
      updateinput = "sudo -v && ${flatpak}/bin/flatpak update && ${nh}/bin/nh os switch -H $NIX_HOST --keep-going --log-format bar-with-logs ./ --update-input";
      cleannix = "sudo -v && ${flatpak}/bin/flatpak uninstall --unused && ${nh}/bin/nh clean all -v --optimise";
      agenixedit = "sudo EDITOR=$EDITOR agenix --identity /etc/ssh/ssh_host_ed25519_key -e";
      sendnix = sendnix;

      ## Alterntives
      mi = "${micro}/bin/micro";
      cat = "${bat}/bin/bat";
      grep = "${ripgrep}/bin/rg";
      df = "${dysk}/bin/dysk";
      sleep = "${timer}/bin/timer";
      vim = "${neovim}/bin/nvim";

      ## ls
      ls = "${eza}/bin/eza --icons";
      ll = "${eza}/bin/eza -lh --icons --grid --group-directories-first";
      la = "${eza}/bin/eza -lah --icons --grid --group-directories-first";
      tree = "${eza}/bin/eza --icons -T";
      links = "${eza}/bin/eza -lh --icons --grid --group-directories-first --hyperlink";

      ## Aliases
      size = "${uutils-coreutils-noprefix}/bin/du -sh";
      img2text = "${tesseract}/bin/tesseract stdin stdout";
      log = "${systemd}/bin/journalctl -xef -u";
      logs = "${systemd}/bin/journalctl -xe -u";
      scrcpy = "${scrcpy}/bin/scrcpy --video-codec=h264
        --video-encoder=OMX.google.h264.encoder --render-driver=opengl";
      stopwatch = "${clock-rs}/bin/clock-rs stopwatch";
      timer = timer;
      olaplay = "${mpv}/bin/mpv --audio-channels=stereo --ad-lavc-downmix=yes";
      hyprpicker = "${hyprpicker}/bin/hyprpicker -a";
      gping = "${gping}/bin/gping -b 200";

      ## Compatibility
      mesalaunch = "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
      browser = "${librewolf}/bin/librewolf";
    };
  };
}
