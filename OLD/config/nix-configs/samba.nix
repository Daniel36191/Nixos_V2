{
  username,
  ...
}:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        securityType = "user";
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
      };
      "nixos" = {
        "path" = "/home/${username}/Desktop/Share";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "read only" = "no";
        "guest ok" = "yes";
        "valid users" = "${username}";
        "force user" = "${username}";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
