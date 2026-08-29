{
  pkgs,
  unstable,
  pkgs-personal,
  ...
}:
let
in
{
  environment.systemPackages = with unstable; [
    streamcontroller
    pkgs-personal.lulzbot-cura
    # lan-mouse ## Software KVM
    songrec
    unstable.razer-cli
    unstable.razergenie
  ];

  ## For Stream Controller
  services.udev.packages = [ pkgs.streamdeck-ui ];

  services.flatpak = {
    packages = [
      # "com.core447.StreamController"
    ];
  };
  services.nix-serve = {
    enable = false;
    package = pkgs.nix-serve-ng;
  };

  services.lact.enable = true;
}
