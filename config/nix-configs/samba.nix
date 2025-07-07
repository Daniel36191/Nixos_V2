{
  ...
}:
{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
      };
      "nixos" = {
        "path" = "/home/daniel/Desktop/Share";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "read only" = "no";
        "guest ok" = "yes";
        "valid users" = "daniel";
        "force user" = "daniel";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
