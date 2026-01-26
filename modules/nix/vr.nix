{
  pkgs,
  inputs,
  ...
}:
let
in
{
  environment.systemPackages = with pkgs; [
    monado-vulkan-layers
    # monado
    wlx-overlay-s ## To See Monitor ## Old version
    # wayvr-dashboard ## App Launcher ## Old version

    opencomposite ## Translation Layer
    # inputs.lemonake.packages.${pkgs.system}.wlx-overlay-s
    inputs.lemonake.packages.${pkgs.system}.wayvr-dashboard

    # slimevr ## slime vr :)

    ## Hotas remapping
    input-remapper

  ]; 
}
