{
    pkgs,
    pkgs-stable,
    username,
    ...
}:
{
  services = {
    syncthing = {
      enable = true;
      systemService = false; ## Ran as user service below
      openDefaultPorts = true;
      # extraFlags = [ "--no-default-folder" ]; # Don't create default ~/Sync folder
      group = "Personal";
      user = "Nixos";
      dataDir = "/home/${username}/Documents";
      configDir = "/home/${username}/.config/syncthing";
    };
  };

  systemd.user.services.syncthing-user = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    description = "File sync service";
    serviceConfig = {
        Type = "simple";
        ExecStart = ''/run/current-system/sw/bin/syncthing -no-browser --no-default-folder'';
    };
  };
}