{
  pkgs,
  username,
  host,
  lib,
  inputs,
  ...
}:
let
  inherit (import ./nix-configs/variables.nix) gitUsername gitEmail;
in
{
  ## Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    ./hm-configs/fastfetch
    ./hm-configs/hyprland/hyprland.nix
    ./hm-configs/rofi/rofi.nix
    ./hm-configs/rofi/config-emoji.nix
    ./hm-configs/rofi/config-long.nix
    ./hm-configs/swaync.nix
    ./hm-configs/waybar.nix
    ./hm-configs/wlogout.nix
    ./hm-configs/desktop-files/desktop-files.nix
  ];

  # Scripts
  home.packages = [
    (import ../scripts/task-waybar.nix { inherit pkgs; })
    (import ../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../scripts/web-search.nix { inherit pkgs; })
    (import ../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../scripts/screenshootin.nix { inherit pkgs; })
    (import ../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ./hm-configs/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ./hm-configs/wlogout;
    recursive = true;
  };
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Styling Options
  stylix.targets = {
    waybar.enable = false;
    rofi.enable = false;
    hyprland.enable = false;
  };
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = lib.mkDefault "adwaita-dark";
    platformTheme.name = lib.mkDefault "gtk3";
  };

  # services = {
  #   hypridle = {
  #     enable = true;
  #     settings = {
  #       general = {
  #         after_sleep_cmd = "hyprctl dispatch dpms on";
  #         ignore_dbus_inhibit = false;
  #         lock_cmd = "hyprlock";
  #         };
  #       listener = [
  #         {
  #           timeout = 900;
  #           on-timeout = "hyprlock";
  #         }
  #         {
  #           timeout = 1200;
  #           on-timeout = "hyprctl dispatch dpms off";
  #           on-resume = "hyprctl dispatch dpms on";
  #         }
  #       ];
  #     };
  #   };
  # };

  programs = {
    gh.enable = true;
    btop = {
      enable = true;
      package = pkgs.btop.override {
        rocmSupport = true;
        cudaSupport = true;
      };
      settings = {
        rounded_corners = true;
        show_gpu_info = "on";
        show_uptime = true;
        show_coretemp = true;
        cpu_sensor = "auto";
        show_disks = true;
        only_physical = true;
        io_mode = true;
        io_graph_combined = false;
      };

    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        fastfetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      shellAliases = {
        vnc = "hyprctl output create headless VNC-1 && wayvnc -o VNC-1 192.168.8.194";
        sudonix = "sudo nixos-rebuild switch --flake .#default";
        updatenix = "sudo nix flake update && sudo nixos-rebuild switch --flake .#default --upgrade";
        cat = "bat";
        mi = "micro";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
      };
    };
    home-manager.enable = true;
    # hyprlock = {
    #   enable = true;
    #   settings = {
    #     general = {
    #       disable_loading_bar = true;
    #       grace = 10;
    #       hide_cursor = true;
    #       no_fade_in = false;
    #     };
    #     lib.mkPrio.background = [
    #       {
    #         path = "/home/${username}/Pictures/Wallpapers/zaney-wallpaper.jpg";
    #         blur_passes = 3;
    #         blur_size = 8;
    #       }
    #     ];
    #     image = [
    #       {
    #         path = "/home/${username}/.config/face.jpg";
    #         size = 150;
    #         border_size = 4;
    #         border_color = "rgb(0C96F9)";
    #         rounding = -1; # Negative means circle
    #         position = "0, 200";
    #         halign = "center";
    #         valign = "center";
    #       }
    #     ];
    #     lib.mkPrio.input-field = [
    #       {
    #         size = "200, 50";
    #         position = "0, -80";
    #         monitor = "";
    #         dots_center = true;
    #         fade_on_empty = false;
    #         font_color = "rgb(CFE6F4)";
    #         inner_color = "rgb(657DC2)";
    #         outer_color = "rgb(0D0E15)";
    #         outline_thickness = 5;
    #         placeholder_text = "Password...";
    #         shadow_passes = 2;
    #       }
    #     ];
    #   };
    # };
  };
}
