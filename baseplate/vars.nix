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

  ############
  ## System ##
  ############
  ssh.authedKeys = [
  ];
  firewall = false;
  timeZone = "New_York";
  locale = "en_US.UTF-8";
}
