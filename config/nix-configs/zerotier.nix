{
  pkgs,
  inputs,
  ...
}:
let
in
{
  services.zerotierone = {
    enable = true;
    port = 12345;

    joinNetworks = [
      "17d709436c7a554e"
    ];
  };
}