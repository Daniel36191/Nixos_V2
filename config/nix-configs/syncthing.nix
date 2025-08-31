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
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          devices = {
            "pc" = { id = "D5L3MPA-SM6HLEH-K2ZZJ5Q-DPH5PKZ-7Z37JGK-XJNFH3V-THMAKM7-Y3BF4AG"; };
            "laptop" = { id = "FBWUU27-IKUMHSD-S2Z4QJM-NWZUFDV-YJ3UI42-QBE4U5L-RK2QKFN-HEFN7AX"; };
          };
          folders = {
            "Documents" = {
              path = "/home/${username}/Documents";
              devices = [
                "pc"
                "laptop"
                ];
            };
            "Desktop" = {
              path = "/home/${username}/Desktop";
              devices = [
                "pc"
                "laptop"
                ];
            };
          };
        };
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