{
  pkgs,
  ...
}:
{

  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      daemon.settings.features.cdi = true;
      rootless.daemon.settings.features.cdi = true;
    };

    # podman = {
    #   enable = true;
    #   dockerCompat = false; ## Create a `docker` alias for podman, to use it as a drop-in replacement
    #   defaultNetwork.settings.dns_enabled = true;
    # };
  };

  environment.systemPackages = with pkgs; [
    # podman-desktop
    # podman-compose
    docker-compose
    nvidia-container-toolkit
    docker-buildx
  ];
}
