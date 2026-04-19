{
  config,
  fun,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  mod = fun.configSelf config __curPos.file;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [
      inputs.hyprdynamicmonitors.packages.${pkgs.system}.default
    ];

    services.hyprdynamicmonitors = {
      enable = true;
      package = inputs.hyprdynamicmonitors.packages.${pkgs.system}.default;
      mode = "user";
      configFile = ./config.toml;
      configPath = "~/.config/hyprdynamicmonitors/config.toml";
    };
  };
}
