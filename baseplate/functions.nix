{
  lib,
  modulesFolder,
  hostsFolder,
  ...
}:
let

  allFiles = d: lib.filesystem.listFilesRecursive d;

  ## Automatic Options ##
  generateModuleOptions =
    let
      mkOpt = lib.mkEnableOption "";

      nixFiles = builtins.filter (p: lib.hasSuffix ".nix" (toString p)) (allFiles modulesFolder);

      parseFile =
        path:
        let
          str = toString path;
          relPath = builtins.elemAt (builtins.split "/modules/" str) 2;
          segs = lib.splitString "/" relPath;
          rest = builtins.tail segs; # drop section
          stem = lib.removeSuffix ".nix" (lib.last rest);
          group = if builtins.length rest > 1 then builtins.head rest else null;
        in
        {
          inherit stem group;
          depth = builtins.length rest;
        };

      parsed = map parseFile nixFiles;

      flatStems = lib.unique (map (p: p.stem) (builtins.filter (p: p.depth == 1) parsed));

      flatEntries = builtins.listToAttrs (
        map (stem: {
          name = stem;
          value = {
            enable = mkOpt;
          };
        }) flatStems
      );

      groupedParsed = builtins.filter (p: p.depth > 1) parsed;
      groupNames = lib.unique (map (p: p.group) groupedParsed);

      buildGroup =
        groupName:
        let
          stems = lib.unique (map (p: p.stem) (builtins.filter (p: p.group == groupName) groupedParsed));

          subAttrs = builtins.listToAttrs (
            map (stem: {
              name = if stem == groupName then "enable" else stem;
              value = if stem == groupName then mkOpt else { enable = mkOpt; };
            }) stems
          );
        in
        {
          name = groupName;
          value = subAttrs;
        };

      groupEntries = builtins.listToAttrs (map buildGroup groupNames);

    in
    flatEntries // groupEntries;

  ## All User SSH Keys ##
  nixConfigFiles = builtins.filter (p: lib.hasSuffix "config.nix" (toString p)) (allFiles hostsFolder);
  hostSSHKeys = lib.forEach nixConfigFiles (p: (import p { }).hostConf.sshPublicKey);
in
{
  inherit generateModuleOptions;
  inherit hostSSHKeys;
}
