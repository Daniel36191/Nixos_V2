#! /usr/bin/env -S nix repl --file
let
  lib = (import <nixpkgs> {}).lib;
generateModuleOptions = files:
  let
    mkOpt = lib.mkEnableOption "";

    allFiles = lib.filesystem.listFilesRecursive files;

    # Filter to .nix only
    nixFiles = builtins.filter
      (p: lib.hasSuffix ".nix" (builtins.toString p))
      allFiles;

    # Parse a path into { stem, depth, group }
    # e.g. ".../modules/home/hyprland/hyprlock.nix"
    #   -> { stem = "hyprlock"; depth = 2; group = "hyprland"; }
    parseFile = path:
      let
        str      = builtins.toString path;
        # builtins.split "/modules/" returns [ before [sep] after ]
        relPath  = builtins.elemAt (builtins.split "/modules/" str) 2;
        segs     = lib.splitString "/" relPath;
        # Drop the section dir (core / home / nix / overlays)
        rest     = builtins.tail segs;
        stem     = lib.removeSuffix ".nix" (lib.last rest);
        group    = if builtins.length rest > 1
                   then builtins.head rest
                   else null;
      in { inherit stem group; depth = builtins.length rest; };

    parsed = map parseFile nixFiles;

    # ── Flat files (depth = 1, directly in section) ──────────────────────────
    flatEntries =
      let
        flatParsed = builtins.filter (p: p.depth == 1) parsed;
        unique     = lib.unique (map (p: p.stem) flatParsed);
      in builtins.listToAttrs (map (stem: { name = stem; value = mkOpt; }) unique);

    # ── Grouped files (depth > 1, inside a subdir) ───────────────────────────
    groupedParsed = builtins.filter (p: p.depth > 1) parsed;
    groupNames    = lib.unique (map (p: p.group) groupedParsed);

    # All .nix stems that belong to a group (deduplicated)
    groupStems = groupName:
      lib.unique (map (p: p.stem)
        (builtins.filter (p: p.group == groupName) groupedParsed));

    buildGroup = groupName:
      let
        stems   = groupStems groupName;
        isSolo  = builtins.length stems == 1
                  && builtins.head stems == groupName;
        # canonical stem (== group name) → "enable", others → their own stem
        subAttrs = builtins.listToAttrs (map (stem: {
          name  = if stem == groupName then "enable" else stem;
          value = mkOpt;
        }) stems);
      in
        if isSolo
        then { name = groupName; value = mkOpt; }    # collapse to flat
        else { name = groupName; value = subAttrs; };

    groupEntries = builtins.listToAttrs (map buildGroup groupNames);

  in
    flatEntries // groupEntries;

  fileToConfigPath = path:
  let
    str     = builtins.toString path;
    relPath = builtins.elemAt (builtins.split "/modules/" str) 2;
    segs    = lib.splitString "/" relPath;
    rest    = builtins.tail segs;
    dirs    = lib.init rest;
    file    = lib.last rest;
    stem    = lib.removeSuffix ".nix" file;
    parent  = if dirs == [] then null else lib.last dirs;
    key     = if stem == parent then "enable" else stem;
    parts   = dirs ++ [ key ];
  in
    "config.mod.${lib.concatStringsSep "." parts}";
in
{
  r = generateModuleOptions ./modules;
  rr = fileToConfigPath;
}
