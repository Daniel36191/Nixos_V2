{
  pkgs,
  ...
}:
{
  programs.fish = {
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  ## Plugins
  environment.systemPackages = with pkgs; [
    fishPlugins.done
    fishPlugins.grc
    grc
    fishPlugins.forgit
  ];
}
