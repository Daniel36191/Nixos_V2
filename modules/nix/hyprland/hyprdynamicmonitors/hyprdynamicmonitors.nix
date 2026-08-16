{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  mod = config.mod.hyprland.hyprdynamicmonitors;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [
      inputs.hyprdynamicmonitors.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    services.hyprdynamicmonitors = {
      enable = true;
      package = inputs.hyprdynamicmonitors.packages.${pkgs.stdenv.hostPlatform.system}.default;
      mode = "user";
      configFile = ./config.toml;
      configPath = "~/.config/hyprdynamicmonitors/config.toml";
    };
  };
}
