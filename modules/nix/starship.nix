{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.nix.starship;
in
{
  config = lib.mkIf mod.enable {
    programs = {
      starship = {
        enable = true;
        settings = {
          add_newline = false;
          buf = {
            symbol = " ";
          };
          c = {
            symbol = " ";
          };
          directory = {
            read_only = " 󰌾";
          };
          docker_context = {
            symbol = " ";
          };
          fossil_branch = {
            symbol = " ";
          };
          git_branch = {
            symbol = " ";
          };
          golang = {
            symbol = " ";
          };
          hg_branch = {
            symbol = " ";
          };
          hostname = {
            ssh_symbol = " ";
          };
          nix_shell = {
            symbol = " ";
          };
          shlvl = {
            disabled = false;
            format = "[$symbol]($style)";
            repeat = true;
            symbol = "❯";
            repeat_offset = 0;
          };
          lua = {
            symbol = " ";
          };
          memory_usage = {
            symbol = "󰍛 ";
          };
          meson = {
            symbol = "󰔷 ";
          };
          nim = {
            symbol = "󰆥 ";
          };
          nodejs = {
            symbol = " ";
          };
          ocaml = {
            symbol = " ";
          };
          package = {
            symbol = "󰏗 ";
          };
          python = {
            symbol = " ";
          };
          rust = {
            symbol = " ";
          };
          swift = {
            symbol = " ";
          };
          zig = {
            symbol = " ";
          };
        };
      };
      dconf.enable = true;
      seahorse.enable = true;
      fuse.userAllowOther = true;
      mtr.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

    };
  };
}
