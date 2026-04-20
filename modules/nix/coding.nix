{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.coding;
in
{
  config = lib.mkIf mod.enable {
    environment.systemPackages = with pkgs; [
      ## Git tools
      lazygit
      git
      github-desktop

      filezilla # Fstp client

      termius

      zellij

      ## Code editors
      vscode
      # zed-editor
      micro
      neovim
      jetbrains.idea

      ## Language servers
      nixd # Nix-lang interpiter
      nil # Nix-lang server
      nixfmt # Nix-lang formattor
      black # Python

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
