{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  mod = osConfig.mod.lite-xl;
in
{
  config = lib.mkIf mod.enable {
    programs.lite-xl = {
      enable = true;
      fonts.enable = true;
      plugins = {
        enableList = [
          "autoinsert"
          "colorpicker"
          "colorpreview"
          "bracketmatch"
          "indentguide"
          "rainbowparen"
          "minimap"
          "motiontrail"
          "sort"
          "sortcss"
          # "spellcheck" # Maybe
          "sticky_scroll"
          "su_save"
          "tabnumbers"
          "terminal"
          "wordcount"
          "editorconfig"
          "lfautoinsert"
          # "ipc"
          "scm"
          "gitdiff_highlight"
          # "gitblame" #scm covers this
          # "gitstatus" # scm covers this
          # "gui_filepicker" # Maybe might like typing more. # Can't find picker'
          "openselected" # Only a command not a bind set or ctrl select
          "restoretabs"
          "selectionhighlight"
          "terminal"
        ];
        customEnableList = {
          "keybinds" = ./keybinds.lua;
          "config" = ./config.lua;
          "color" = ./catppuccin-macchiato.lua;
          "nerdicons" = ./plugins/nerdicons.lua;
          "find-fun" = ./plugins/find-fun.lua;
          "unsaved" = ./plugins/find-fun.lua;
        };
        languages = {
          enableList = [
            "ts" # TypeScript/JavaScript
            "sass" # CSS, Less, Sass
            "json" # JSON/JSONC
            "rust" # Rust
            "zig" # Zig
            "yaml" # YAML
            "toml" # TOML
            "sh" # Bash
            "tex" # LaTeX
            "kotlin" # Kotlin
            "java" # Java
            "csharp" # C#
            "glsl" # GLSL shaders
          ];
          customEnableList = {
            "containerfile" = ./languages/containerfile.lua; # Dockerfiles
            "nix" = ./languages/nix.lua; # Nixlang
          };
        };
        lsp = {
          addPackages = true;
          enableList = [
            "nil_ls" # Nixlang
            "typescript_ls" # TypeScript/JavaScript
            "vscode_css_ls" # CSS, Less, Sass
            "vscode_json_ls" # JSON/JSONC
            "python_ls" # Python
            "pyright" # Python type checker
            "basedpyright" # Python type checker
            "ruff" # Python linter/formatter
            "clangd" # C/C++
            # "rust_analyzer" # Rust # Collision between rustup and cargo
            "tailwind_css_ls" # HTML
            "zls" # Zig
            "yaml_ls" # YAML
            "taplo" # TOML
            "lemminx" # XML
            "dockerfile_ls_nodejs" # Dockerfiles
            "bash_ls" # Bash
            "lua_ls" # Lua
            "marksman" # Markdown
            "texlab" # LaTeX
            "jdtls" # Java
            "omnisharp" # C#
            "glsl_analyzer" # GLSL shaders
          ];
        };
        lintplus = {
          enableList = [
            "luacheck"
            "shellcheck"
          ];
          addPackages = true;
          copyLanguages.enable = true;
        };
      };
      libraries = {
        customEnableList = {
          "font_symbols_nerdfont_mono_regular" = ./libraries/font_symbols_nerdfont_mono_regular.lua;
        };
      };
    };
    # /share/fonts/truetype/NerdFonts/Symbols/SymbolsNerdFontMono-Regular.ttf
    home.file.".config/lite-xl/libraries/font_symbols_nerdfont_mono_regular/SymbolsNerdFontMono-Regular.ttf".source =
      "${pkgs.nerd-fonts.symbols-only}/share/fonts/truetype/NerdFonts/Symbols/SymbolsNerdFontMono-Regular.ttf";
  };
}
