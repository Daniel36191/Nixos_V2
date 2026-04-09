let
  lib = (import <nixpkgs> {}).lib;

  autoModules = let

    filterdNixModules = dir: lib.lists.filter
      (f: ( builtins.match ".*\.nix" 
        (baseNameOf (toString f))) != null )
      (lib.filesystem.listFilesRecursive dir)
    ;

    allowedSubFolders = "nix|home|core";
    enabledModules2 = dir:
      let
        matched = f: builtins.match "${toString dir}\/(${allowedSubFolders})\/(.*)\.nix" (toString f);
        validFiles = builtins.filter (f: matched f != null) (filterdNixModules dir);
      in
        map (f: builtins.head (builtins.tail (matched f))) validFiles;






    parts = lib.splitString "/" "modules/nix/hyprland/hyprppan";
    # [ "modules" "nix" "hyprland" "hyprland" ]

    # Check if last two parts are the same
    len = builtins.length parts;
    last = builtins.elemAt parts (len - 1);
    secondLast = builtins.elemAt parts (len - 2);

    # Drop the duplicate last segment if they match
    attrPath = if last == secondLast
      then (lib.init parts) ++ [ "enable" ]
      else parts;

    test2 = lib.setAttrByPath attrPath true;

  in dir: enabledModules2 dir;



## options.modules.hyprland.hyprdynamicmonitors.monitors = { enable = lib.mkEnableOption {default = false;}
  

in { r = autoModules ./modules; }