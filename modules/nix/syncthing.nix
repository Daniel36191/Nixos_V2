{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.syncthing;
in
{
  config = lib.mkIf mod.enable {
    # services = { ## Breaks systemd serice
    #   syncthing = {
    #     enable = true;
    #     systemService = false; ## Ran as user service below
    #     openDefaultPorts = true;
    #     # extraFlags = [ "--no-default-folder" ]; # Don't create default ~/Sync folder
    #     group = "Personal";
    #     user = "Nixos";
    #     dataDir = "/home/${username}/Documents";
    #     configDir = "/home/${username}/.config/syncthing";
    #   };
    # };
    environment.systemPackages = with unstable; [
      syncthing
    ];

    systemd.user.services.syncthing = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      description = "File sync service";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.syncthing}/bin/syncthing
          syncthing cli config gui raw-address set 0.0.0.0:8384
        '';
        Restart = "on-failure";
      };
    };
  };
}
