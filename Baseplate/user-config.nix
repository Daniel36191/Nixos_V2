{
  ...
}:
{  
  options.usrConfig = {

    ##########
    ## User ##
    ##########
    username = "daniel";
    hostname = "nixos";
    git = {
      username = "Daniel36191";
      email = "dmoeller3998@gmail.com";
    };


    ############
    ## System ##
    ############
    ssh.authedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIv464AZB6omIM7lrgKqZKnK62iP72YOrcYsV9pplsyF lillypond@lillypond" ## Make this into a imported value
    ];
    timeZone = "New_York";
    locale = "en_US.UTF-8";
  };
}
