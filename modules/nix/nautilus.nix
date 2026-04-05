{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [    
    nautilus
    turtle ## git for nautilus
    code-nautilus ## open in code
    nautilus-python
  ];
  services = {
    gnome.sushi.enable = true;
    gvfs = {
      enable = true;
      package = pkgs.gnome.gvfs;
    };
  };
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     nautilus = prev.nautilus.overrideAttrs (nprev: {
  #       buildInputs =
  #         nprev.buildInputs
  #         ++ (with pkgs.gst_all_1; [
  #           gst-plugins-good
  #           gst-plugins-bad
  #         ]);
  #     });
  #   })
  # ];
  # environment.variables = {
  #   GIO_EXTRA_MODULES = lib.mkDefault "${pkgs.gvfs}/lib/gio/modules"; ## Fixes Network tab not working
  # };
  # environment.sessionVariables = {
  #   NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
  # };
  # environment.pathsToLink = [ 
  #  "/share/nautilus-python/extensions" 
  # ]; 
}