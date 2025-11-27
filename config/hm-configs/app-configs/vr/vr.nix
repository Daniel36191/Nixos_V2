{
	pkgs,
	...
}:
let
  watch = builtins.readFile ./watch.ymal;
  wayvr = builtins.readFile ./wayvr.ymal;
in
{
	# home.file.".config/wlxoverlay/watch.ymal".text = lib.strings.concatStrings [ watch ];
	# home.file.".config/wlxoverlay/wayvr.ymal".text = lib.strings.concatStrings [ wayvr ];

	xdg.configFile."openvr/openvrpaths.vrpath".text = ''
  {
    "config" :
    [
      "/home/USERNAME/.local/share/Steam/config"
    ],
    "external_drivers" : null,
    "jsonid" : "vrpathreg",
    "log" :
    [
      "/home/USERNAME/.local/share/Steam/logs"
    ],
    "runtime" :
    [
      "${pkgs.xrizer}/lib/xrizer"
    ],
    "version" : 1
  }
'';

}
