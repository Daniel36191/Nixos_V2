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
        systemService = true;
        group = "Personal";
        user = "Nixos";
        dataDir = "/home/myusername/Documents";
        configDir = "/home/myusername/Documents/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          devices = {
            "pc" = { id = "DEVICE-ID-GOES-HERE"; };
            "laptop" = { id = "DEVICE-ID-GOES-HERE"; };
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
    networking.firewall = {
        allowedTCPPorts = [ 8384 22000 ];
        allowedUDPPorts = [ 22000 21027 ];
    };
}