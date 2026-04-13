{
  lib,
  ...
}:
let
  ## Config
  modulesFolder = ../modules;
  allowedSubFolders = "nix|home|core";

  ## Functions
  getNixFiles =
    dir:
    lib.filter (f: builtins.match ".*\\.nix" (baseNameOf (toString f)) != null) (
      lib.filesystem.listFilesRecursive dir
    );

  matchFile = dir: f: builtins.match "${toString dir}/(${allowedSubFolders})/(.+)\\.nix" (toString f);

  getModulePaths =
    dir:
    lib.lists.concatMap (
      f:
      let
        m = matchFile dir f;
      in
      if m == null then [ ] else [ (builtins.elemAt m 1) ]
    ) (getNixFiles dir);

  toAttrPath =
    path:
    let
      parts = lib.splitString "/" path;
      len = builtins.length parts;
      last = builtins.elemAt parts (len - 1);
      secondLast = if len >= 2 then builtins.elemAt parts (len - 2) else null;
      dedupedParts = if len >= 2 && last == secondLast then lib.init parts else parts;
    in
    dedupedParts ++ [ "enable" ];

  autoOptions =
    dir:
    lib.foldl' lib.recursiveUpdate { } (
      map (p: lib.setAttrByPath (toAttrPath p) (lib.mkEnableOption "" // { default = false; })) (
        getModulePaths dir
      )
    );
in
{
  ## Outputs
  options.modules = autoOptions modulesFolder;
}
