{
...
}:
{
# virtualisation.docker.enable = true;

virtualisation = {
  containers.enable = true;
  podman = {
    enable = true;
    dockerCompat = false; ## Create a `docker` alias for podman, to use it as a drop-in replacement
    defaultNetwork.settings.dns_enabled = true;
  };
};
}
