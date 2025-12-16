let
  ## Host public ssh key foubd by cat /etc/ssh/ssh_host_ed25519_key.pub
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDxtdHPYyJYTFXZMIk11RvinkU7Fk0kUZ7BND8vpgJuK";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxMd0Bm0iX1OEXnnyRf/kF6eogn/zk3cPSfm23oMUwP";
  systems = [
    pc
    laptop
  ];
in
{
  ## make new files/edit with agenixedit file.age
  "tailscale-pc.age".publicKeys = systems;
  "tailscale-laptop.age".publicKeys = systems;
}