{
  ...
}:
{
  home.file.".config/lan-mouse/config.toml".text = ''
    [left]
    # hostname = "Windows"
    hostname = "192.168.0.189"
    activate_on_startup = true
    ips = ["192.168.8.154", "192.168.0.189"]
  '';
}
