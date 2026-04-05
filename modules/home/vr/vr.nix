{
	pkgs,
	inputs,
	config,
  lib,
	...
}:
{
	home.file.".config/wlxoverlay/watch.ymal" = { source = ./watch.yaml; force = true; };

	# home.file.".config/wlxoverlay/wayvr.ymal" = {
	# 	force = true;
	# 	text = ''
	# 	{
  # 		"config" :
  # 		[
  # 		  "/home/USERNAME/.local/share/Steam/config"
  # 		],
  # 		"external_drivers" : null,
  # 		"jsonid" : "vrpathreg",
  # 		"log" :
  # 		[
  # 		  "/home/USERNAME/.local/share/Steam/logs"
  # 		],
  # 		"runtime" :
  # 		[
  # 		  "${config.services.wivrn.config.json.openvr-compat-path}/lib/${lib.strings.removePrefix "pkgs." "${config.services.wivrn.config.json.openvr-compat-path}"}"
  # 		],
  # 		"version" : 1
	# 	}
	# 	'';
	# };
  # 
	# home.file.".config/wlxoverlay/wayvr.conf.d/dashboard.yaml" = { 
	# 	force = true;
	# 	text = ''
	# 		dashboard:
  # 	exec: "${inputs.lemonake.packages.${pkgs.system}.wayvr-dashboard}"
  # 	args: ""
  # 	env: []
	# 	'';
	# };

}
