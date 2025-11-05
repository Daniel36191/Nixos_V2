{
  config,
  ...
}:
{
  services.hyprdynamicmonitors = {
    enable = true;
    mode = "user";
    # configFile = ./config.toml;
    configPath = "~/.config/hyprdynamicmonitors/config.toml";
  };
}