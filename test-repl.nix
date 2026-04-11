let
  lib = (import <nixpkgs> {}).lib;

  autoModules = dir:
    let
      allowedSubFolders = "nix|home|core";

      nixFiles = lib.filter
        (f: builtins.match ".*\\.nix" (baseNameOf (toString f)) != null)
        (lib.filesystem.listFilesRecursive dir);

      matchFile = f: builtins.match
        "${toString dir}/(${allowedSubFolders})/(.+)\\.nix"
        (toString f);

      modulePaths = lib.lists.concatMap
        (f: let m = matchFile f; in if m == null then [] else [ (builtins.elemAt m 1) ])
        nixFiles;

      toAttrPath = path:
        let
          parts = lib.splitString "/" path;
          len = builtins.length parts;
          last = builtins.elemAt parts (len - 1);
          secondLast = if len >= 2 then builtins.elemAt parts (len - 2) else null;
          dedupedParts = if len >= 2 && last == secondLast then lib.init parts else parts;
        in
          dedupedParts ++ [ "enable" ];

      attrSets = map (p: lib.setAttrByPath (toAttrPath p) (lib.mkEnableOption "" // { default = false; })) modulePaths;

    in
      lib.foldl' lib.recursiveUpdate {} attrSets;

in {
  r = autoImport ./modules;
  r1 = autoModules ./modules;
}