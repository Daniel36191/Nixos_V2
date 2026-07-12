{
  ##########
  ## User ##
  ##########
  username = "daniel";
  hostname = "nixos";
  wallpaper = "yourname-1.png";
  git = {
    username = "Daniel36191";
    email = "dmoeller3998@gmail.com";
  };
  firewall = false;
  timeZone = "New_York";
  locale = "en_US.UTF-8";

  ############
  ## System ##
  ############
  ssh = {
    authedKeys = [
    ];
    matchBlocks = {
      "lillypond.local" = {
        hostname = "lillypond.local";
        port = 22;
        user = "lillypond";
      };

      "root.lillypond.local" = {
        hostname = "lillypond.local";
        port = 22;
        user = "root";
      };

      "lillypond-tailscale" = {
        hostname = "lillypond";
        port = 22;
        user = "lillypond";
      };

      "mule.local" = {
        hostname = "192.168.1.59";
        port = 22;
        user = "beachmule";
      };
    };
  };
}
