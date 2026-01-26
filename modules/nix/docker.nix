{
  pkgs,
  ...
}:
{

  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        features.cdi = true;
      };
      # rootless.daemon.settings.features.cdi = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    # nvidia-container-toolkit
    docker-buildx
  ];
}
