{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.kitty;
in
{
  config = lib.mkIf mod.enable {
    programs = {
      kitty = {
        enable = true;
        package = pkgs.kitty;
        font = {
          package = lib.mkDefault pkgs.red-hat-display-nerd;
          name = lib.mkDefault "Miracode Nerd Font";
        };
        settings = {
          scrollback_lines = 2000;
          wheel_scroll_min_lines = 1;
          window_padding_width = 4;
          confirm_os_window_close = 0;
        };
        extraConfig = ''
          tab_bar_style fade
          tab_fade 1
          active_tab_font_style   bold
          inactive_tab_font_style bold
        '';
      };
    };
  };
}
