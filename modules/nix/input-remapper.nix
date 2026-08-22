{
  config,
  lib,
  ...
}:
let
  mod = config.mod.input-remapper;
in
{
  config = lib.mkIf mod.enable {
    services.input-remapper = {
      enable = true;
    };
  };
}
