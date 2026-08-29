{
  config,
  lib,
  unstable,
  host,
  ...
}:
let
  mod = config.mod.diskHealth;
in
{
  config = lib.mkIf mod.enable {
    services.scrutiny = {
      ## No Ui
      enable = false;
      package = unstable.scrutiny;
      collector = {
        enable = true;
        package = unstable.scrutiny-collector;
        settings = {
          host.id =
            lib.toUpper (builtins.substring 0 1 host)
            + builtins.substring 1 (builtins.stringLength host - 1) host;
          log.level = "DEBUG";
          api.endpoint = "http://192.168.0.189:8546";
        };
      };
    };
  };
}
