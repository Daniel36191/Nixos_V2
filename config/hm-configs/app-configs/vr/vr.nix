{
	pkgs,
  lib,
	...
}:
let
  # watch = builtins.readFile ./watch.ymal;
  # wayvr = builtins.readFile ./wayvr.ymal;
in
{
	# home.file.".config/wlxoverlay/watch.ymal" = { text = lib.strings.concatStrings [ watch ]; force = true; };

	home.file.".config/wlxoverlay/wayvr.ymal" = { source = ./wayvr.yaml; force = true; };
}
