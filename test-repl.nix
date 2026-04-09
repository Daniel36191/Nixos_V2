let
  lib = (import <nixpkgs> {}).lib;

  autoModules = let

    filterdNixModules = dir: lib.lists.filter
      (f: ( builtins.match ".*\.nix" 
        (baseNameOf (toString f))) != null )
      (lib.filesystem.listFilesRecursive dir)
    ;

    allowedSubFolders = "nix|home|core";
    enabledModules = dir: lib.lists.forEach 
      (filterdNixModules dir)
      (f: builtins.head
        (builtins.tail
          (builtins.match ".*\/${baseNameOf ./.}\/modules\/(${allowedSubFolders})\/(.*)\.nix"
            (toString f)
          )
        )
      );






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

  in dir: enabledModules dir;



## options.modules.hyprland.hyprdynamicmonitors.monitors = { enable = lib.mkEnableOption {default = false;}
  

in { r = autoModules ./modules; }