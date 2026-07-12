{
  lib,
  osConfig,
  ...
}:
let
  mod = osConfig.mod.fastfetch;
in
{
  config = lib.mkIf mod.enable {
    programs.fastfetch = {
      enable = true;

      settings = {
        display = {
          color = {
            keys = "35";
            output = "90";
          };
        };

        logo = {
          padding = {
            top = 3;
            left = 3;
          };
        };

        modules = [
          "break"
          {
            type = "custom";
            format = "┌──────────────────────Hardware──────────────────────┐";
          }
          {
            type = "cpu";
            key = "│  ";
          }
          {
            type = "gpu";
            key = "│  ";
          }
          {
            type = "memory";
            key = "│  ";
          }
          {
            type = "board";
            key = "│ 󰌢 ";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "custom";
            format = "┌───────────────────────Storage──────────────────────┐";
          }
          {
            type = "disk";
            key = "│  ";
            showRemovable = false;
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "custom";
            format = "┌──────────────────────Software──────────────────────┐";
          }
          {
            type = "os";
            key = "┌ 󱄅 ";
          }
          {
            type = "kernel";
            key = "├  ";
          }
          {
            type = "packages";
            key = "├ 󰏖 ";
          }
          {
            type = "wm";
            key = "├ 󱂬 ";
          }
          {
            type = "shell";
            key = "├  ";
          }
          {
            type = "terminal";
            key = "└  ";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "custom";
            format = "┌────────────────────Uptime / Age────────────────────┐";
          }
          {
            type = "command";
            key = "│ 󰃰 ";
            text = ''
              birth_install=$(stat -c %W /)
              current=$(date +%s)
              delta=$((current - birth_install))
              delta_days=$((delta / 86400))
              echo $delta_days days
            '';
          }
          {
            type = "uptime";
            key = "│ 󰅐 ";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          "break"
        ];
      };
    };
  };
}
