{
  ...
}:
{
  home.file."~/.config/waybar/scripts" = {
    enable = true;
    recursive = true;
    source = ./scripts;
    target = ".config/waybar/scripts";
  };
}