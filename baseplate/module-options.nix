{
  fun,
  lib,
  ...
}:
let
in
{
  options = {
    mod = fun.generateModuleOptions;
    hostConf = {
      sshPublicKey = lib.mkOption {};
    };
  };
}
