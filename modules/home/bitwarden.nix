{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.modules.${lib.removeSuffix ".nix" (baseNameOf __curPos.file)};

in
{
  config = lib.mkIf mod.enable {
    home.file.".librewolf/native-messaging-hosts/com.8bit.bitwarden.json".text = builtins.toJSON {
      name = "com.8bit.bitwarden";
      description = "Bitwarden desktop <-> browser bridge";
      path = "${pkgs.bitwarden-desktop}/libexec/desktop_proxy";
      type = "stdio";
      allowed_extensions = [ "{446900e4-71c2-419f-a6a7-df9c091e268b}" ];
    };
  };
}
