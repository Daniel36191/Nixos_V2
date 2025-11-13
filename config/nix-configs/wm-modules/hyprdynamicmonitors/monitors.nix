{
  config,
  inputs,
  pkgs,
  ...
}:
{
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
}