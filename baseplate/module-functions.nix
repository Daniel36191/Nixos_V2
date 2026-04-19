{
  lib,
  dir,
  ...
}:
let
  getNixFiles = lib.filter (f: builtins.match ".*\\.nix" (baseNameOf (toString f)) != null) (
    lib.filesystem.listFilesRecursive dir
  );

  matchFile = f: builtins.match "${toString dir}/(nix|home|core)/(.+)\\.nix" (toString f);

  getModulePaths = lib.lists.unique (
    lib.lists.concatMap (
      f:
      let
        m = matchFile f;
      in
      if m == null then [ ] else [ (builtins.elemAt m 1) ]
    ) getNixFiles
  );

  toAttrPath =
    path:
    let
      parts = lib.splitString "/" path;
      len = builtins.length parts;
      last = builtins.elemAt parts (len - 1);
      secondLast = if len >= 2 then builtins.elemAt parts (len - 2) else null;
      dedupedParts = if len >= 2 && last == secondLast then lib.init parts else parts;
    in
    [ "mod" ] ++ dedupedParts;

  autoOptions = lib.foldl' lib.recursiveUpdate { } (
    map
      (
        p: lib.setAttrByPath (toAttrPath p ++ [ "enable" ]) (lib.mkEnableOption "" // { default = false; })
      )
      (
        lib.lists.unique (
          map (
            p:
            let
              parts = lib.splitString "/" p;
              stripped = lib.tail parts;
            in
            lib.concatStringsSep "/" stripped
          ) getModulePaths
        )
      )
  );

  configSelf =
    config: file:
    let
      m = matchFile file;
      path = builtins.elemAt m 1;
    in
    lib.attrByPath (toAttrPath path) { } config;
in
{
  inherit autoOptions configSelf;
}
