{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
let
  mod = config.mod.coding;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with unstable; [
      ## Git tools
      lazygit
      git
      gitnuro

      filezilla # Fstp client

      termius

      unstable.devenv

      zellij

      ## Code editors
      vscode
      unstable.gram
      # zed-editor
      micro
      neovim
      jetbrains.idea

      ## Language servers
      nixd # Nix-lang interpiter
      nil # Nix-lang server
      nixfmt # Nix-lang formattor
      black # Python
      hyprls # Hyprland

      ## Java
      jdk21

    ];

    environment.variables = {
      EDITOR = "${pkgs.micro}/bin/micro";
    };

    programs.java = {
      enable = true;
      package = pkgs.jdk21;
    };
  };
}
