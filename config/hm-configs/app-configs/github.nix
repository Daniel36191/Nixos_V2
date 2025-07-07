{
  ...
}:
let
  inherit (import ../../variables.nix)
    gitUsername
    gitEmail
    ;
in
{
  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };
  programs = {
    gh.enable = true;
  };
}
