{
  description = "NixOS";

  inputs = {
    #############
    ## Nixpkgs ##
    #############
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/25.11";
    nixpkgs-personal.url = "github:Daniel36191/nixpkgs-personal";

    ##########
    ## Pins ##
    ##########
    nixpkgs-spotifyPin.url = "github:nixos/nixpkgs/nixos-unstable";

    #############
    ## Desktop ##
    #############
    hyprland = {
      url = "github:hyprwm/Hyprland/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms.url = "github:AvengeMedia/DankMaterialShell";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###########
    ## Tools ##
    ###########
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    blender-cuda.url = "github:edolstra/nix-warez?dir=blender";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    lemonake = {
      url = "github:passivelemon/lemonake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-stable,
      nixpkgs-personal,
      nixpkgs-spotifyPin,
      home-manager,
      nix-flatpak,
      blender-cuda,
      hyprsplit,
      hyprdynamicmonitors,
      quickshell,
      dms,
      noctalia,
      nix-index-database,
      agenix,
      nixos-hardware,
      lemonake,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      modulesFolder = ./modules;

      var = import ./baseplate/vars.nix;
      fun = import ./baseplate/module-functions.nix {
        inherit lib;
        inherit modulesFolder;
      };

      commonArgs = {
        inherit inputs var fun;
        pkgs-spotifyPin = import nixpkgs-spotifyPin {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-personal = nixpkgs-personal.packages.${system};
      };

      commonNixModules = [
        ./baseplate/module-options.nix
        ./baseplate/nix-main.nix
        ./baseplate/overlays.nix
        ./secrets/secrets-nix.nix
        inputs.stylix.nixosModules.stylix
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        hyprdynamicmonitors.nixosModules.default
        nix-index-database.nixosModules.default
      ];

      commonHmModules = [
        ./baseplate/hm-main.nix
        ./baseplate/module-options.nix
        # inputs.stylix.homeModules.stylix
      ];

      mkHost =
        host: extraNixModules: extraHmImports:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonArgs // {
            inherit host;
          };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = commonArgs // {
                  inherit host;
                };
                users.${var.username}.imports = commonHmModules ++ extraHmImports ++ [ ];
              };
            }
          ]
          ++ commonNixModules
          ++ extraNixModules
          ++ [ ];
        };

    in
    {
      nixosConfigurations = {
        pc =
          mkHost "pc"
            [
              # Nix Modules
            ]
            [
              # Hm Modules
            ];

        laptop =
          mkHost "laptop"
            [
              # Nix Modules
              nixos-hardware.nixosModules.framework-13-7040-amd
            ]
            [
              # Hm Modules
            ];
      };
    };
}
