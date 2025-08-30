{
	...
}:
let
  watch = builtins.readFile ./watch.ymal;
  wayvr = builtins.readFile ./wayvr.ymal;
in
{
	home.file.".config/wlxoverlay/watch.ymal".text = lib.strings.concatStrings [ watch ];
	home.file.".config/wlxoverlay/wayvr.ymal".text = lib.strings.concatStrings [ wayvr ];
}
