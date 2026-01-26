{
  gitUsername,
  gitEmail,
  ...
}:
{
  ## Install & Configure Git
  programs.git = {
    enable = true;
    settings.user = {
      Name = "${gitUsername}";
      Email = "${gitEmail}";
    };
  };
  programs = {
    gh.enable = true;
  };
}
