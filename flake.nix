{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/25.05";
    nixpkgs-old.url = "github:nixos/nixpkgs/24.11";
    nixpkgs-spotifyOld.url = "github:nixos/nixpkgs/6eb01a67e1fc558644daed33eaeb937145e17696"; ## spotify version 1.2.48.405.gf2c48e6f
    # nixpkgs-spotifyOld.url = "github:nixos/nixpkgs/e6f23dc08d3624daab7094b701aa3954923c6bbb"; ## spotify version 1.2.60.564.gcc6305cb
    spicetify-nix.url = "github:Gerg-L/spicetify-nix/24.11";
    # spicetify-nix.inputs.nixpkgs.follows = "nixpkgs-spotifyOld";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    blender-cuda.url = "github:edolstra/nix-warez?dir=blender"; ## Blender-bin (now with cuda)
    lemonake.url = "github:passivelemon/lemonake";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprsplit.url = "github:shezdy/hyprsplit";
    hyprsplit.inputs.hyprland.follows = "hyprland";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master"; ## For Framework
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-old,
      home-manager,
      nix-flatpak,
      nixpkgs-xr,
      blender-cuda,
      lemonake,
      nixpkgs-spotifyOld,
      hyprsplit,
      quickshell,
      # nixos-hardware,
      ...
    }@inputs:
    let
      inherit (import ./config/variables-global.nix)
        gitUsername
        gitEmail
        system
        keyboardLayout
        consoleKeyMap
        locale
        timeZone
        ;
      
      # Common function to create arguments for both systems
      makeCommonArgs = host: hostVars: {
        nix-host = host;
        inherit gitUsername gitEmail system keyboardLayout;
        inherit consoleKeyMap locale timeZone inputs;
        inherit (hostVars) username hostname wallpaper firewall;
        
        ## Pinning Nixpkgs versions
        pkgs-spotifyOld = import nixpkgs-spotifyOld {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-old = import nixpkgs-old {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-nixpkgs-xr = import nixpkgs-xr {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {

      ########
      ## Pc ##
      ########

      nixosConfigurations = {
        "pc" = nixpkgs.lib.nixosSystem {
          specialArgs = let
            pcVars = import ./config/pc/variables-pc.nix;
          in makeCommonArgs "pc" pcVars;
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.extraSpecialArgs = let
                pcVars = import ./config/pc/variables-pc.nix;
              in makeCommonArgs "pc" pcVars;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${(import ./config/pc/variables-pc.nix).username} = import ./config/pc/hm-main-pc.nix;
              };
            }
            nixpkgs-xr.nixosModules.nixpkgs-xr
            ./config/pc/nix-main-pc.nix
            inputs.stylix.nixosModules.stylix
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
          ];
        };
      };


      ############
      ## Laptop ##
      ############

      nixosConfigurations = {
        "laptop" = nixpkgs.lib.nixosSystem {
          specialArgs = let
            laptopVars = import ./config/laptop/variables-laptop.nix;
          in makeCommonArgs "laptop" laptopVars;
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.extraSpecialArgs = let
                laptopVars = import ./config/laptop/variables-laptop.nix;
              in makeCommonArgs "laptop" laptopVars;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${(import ./config/laptop/variables-laptopaa.nix).username} = import ./config/laptop/hm-main-laptop.nix;
              };
            }
            # nixos-hardware.nixosModules.framework-13-7040-amd ## Install hardware for framework
            nixpkgs-xr.nixosModules.nixpkgs-xr
            ./config/laptop/nix-main-laptop.nix
            inputs.stylix.nixosModules.stylix
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}