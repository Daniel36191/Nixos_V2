let
  githubUser = "Daniel36191";
  host = builtins.getEnv "NIX_HOST";
  remoteUrl = "github:${githubUser}/${baseNameOf (toString ./.)}/main";
  flake = builtins.getFlake remoteUrl;
in
  lib = flake.nixpkgs.lib;


let 
  githubUser = "Daniel36191";
  host = builtins.getEnv "NIX_HOST";
  remoteUrl = "github:${githubUser}/${baseNameOf (toString ./.)}/main";
  flake = (builtins.getFlake remoteUrl).nixosConfigurations.${host};
  user = builtins.head (builtins.attrNames (flake).config.home-manager.users);
 in 
  (flake).options.home-manager.users.value."${user}"