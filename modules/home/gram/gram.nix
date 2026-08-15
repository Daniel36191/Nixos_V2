{
  osConfig,
  config,
  lib,
  pkgs-unstable,
  inputs,
  ...
}:
let
  mod = osConfig.mod.gram;

  gram-extensions = inputs.gram-extensions.packages.${pkgs-unstable.system};
  extensions = with gram-extensions; [
    catppuccin
    catppuccin-icons
  ];
  extensions-dir = gram-extensions.linkGramExtensions extensions;
in
{
  config = lib.mkIf mod.enable {
    home.packages = with pkgs-unstable; [
      gram
      nodejs
    ];
    xdg.dataFile."gram/extensions/installed" = {
      enable = true;
      source = extensions-dir;
      onChange = ''
        cd "${config.xdg.dataHome}/gram/extensions"
        mv index.json index.json.backup
      '';
    };

    home.file.".config/gram/settings.jsonc" = {
      force = true;
      source = ./settings.jsonc;
    };
    home.file.".config/gram/keymap.jsonc" = {
      force = true;
      source = ./keymap.jsonc;
    };
    home.file.".config/gram/snippets/" = {
      force = true;
      source = ./snippets;
    };

  };
}
