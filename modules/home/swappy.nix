{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.swappy;
in
{
  config = lib.mkIf mod.enable {
    home.file.".config/swappy/config".text = ''
      [Default]
      save_dir=/home/${config.mod.username}/Pictures/Screenshots
      save_filename_format=swappy-%Y%m%d-%H%M%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=Ubuntu
      paint_mode=brush
      early_exit=true
      fill_shape=false
    '';
  };
}
