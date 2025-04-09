# NixOS Configuration - Hyprland

![NixOS](https://img.shields.io/badge/NixOS-23.11-blue.svg?logo=nixos&logoColor=white)
![Hyprland](https://img.shields.io/badge/Window_Manager-Hyprland-blueviolet)
![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin-ff69b4)

My personal NixOS configuration for a home PC featuring:
- Hyprland (Wayland compositor)
- Catppuccin theme (Mocha flavor)
- Home Manager for user-specific configuration
- Fully declarative system setup

## Features

### Desktop Environment
- 🖼️ **Hyprland** - Dynamic tiling Wayland compositor
- 🖥️ **Waybar** - Customizable status bar
- 🔍 **Rofi** - Application launcher with Catppuccin skin
- 🎨 **Catppuccin** - Soothing pastel theme for:
  - GTK apps
  - Qt apps
  - Alacritty terminal
  - Waybar
  - Rofi

### System Configuration
- 📦 **Nix Flakes** - For reproducible builds
- 🏠 **Home Manager** - User environment management

## Installation

1. **Clone this repository**:
   ```bash
   git clone https://github.com/yourusername/nixos-config.git /etc/nixos
   cd /etc/nixos
