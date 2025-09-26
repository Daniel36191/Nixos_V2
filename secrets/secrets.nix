let
  ## Host public ssh key foubd by cat /etc/ssh/ssh_host_ed25519_key.pub
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnEroABBEofeQFFpUxifyT8RUg5g6KmtJV8bW6zV2NA";
  # laptop = "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
  systems = [
    pc
    # laptop
  ];
in
{
  ## make new files/edit with agenixedit -e file.age
  "tailscale.age".publicKeys = systems;
}