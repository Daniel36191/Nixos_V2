{
  fun,
  lib,
  ...
}:
let
in
{
  options = {
    mod = fun.autoOptions.mod;
    hostConf = {
      sshPublicKey = lib.mkOption {};
    };
  };
}
