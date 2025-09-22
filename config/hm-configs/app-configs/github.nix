{
  gitUsername,
  gitEmail,
  ...
}:
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
