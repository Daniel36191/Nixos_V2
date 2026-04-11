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

    nixpkgs-spotifyPin.url = "github:nixos/nixpkgs/6eb01a67e1fc558644daed33eaeb937145e17696"; ## spotify version 1.2.48.405.gf2c48e6f
    # nixpkgs-spotifyPin.url = "github:nixos/nixpkgs/e6f23dc08d3624daab7094b701aa3954923c6bbb"; ## spotify version 1.2.60.564.gcc6305cb ## Now playing bugged 


    ############
    ## Inputs ##
    ############

    ## Apps ##
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blender-cuda.url = "github:edolstra/nix-warez?dir=blender"; ## Blender-bin (now with cuda)  
    hyprland ={
      url = "github:hyprwm/Hyprland/main"; ## Unstable Git For windwo rules, unpin for v0.53.*
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell"; ## Shell and theme
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # millennium.url = "git+https://github.com/SteamClientHomebrew/Millennium"; ## Custom Steam Client

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## System ##
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; ## For Framework
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-stable,
      nixpkgs-personal,
      home-manager,
      nix-flatpak,
      blender-cuda,
      nixpkgs-spotifyPin,
      hyprsplit,
      hyprdynamicmonitors,
      quickshell,
      dms,
      noctalia,
      # millennium,
      nix-index-database,
      agenix,
      nixos-hardware,
      ...
    }@inputs:
    let      
      system = "x86_64-linux";

      usrConfig = (nixpkgs.lib.nixosSystem 
        { system = "x86_64-linux"; modules = [./Baseplate/user-config.nix];}
          ).config.usrConfig;

      ## Common function to create arguments for systems
      commonArgs = host: hostVars: {
        nix-host = host;
        
        ## Pinning Nixpkgs versions
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
      };

      commonNixModules = [
        ./baseplate/nix-main.nix
        ./baseplate/options.nix
        ./baseplate/user-config.nix
        # nixpkgs-xr.nixosModules.nixpkgs-xr
        inputs.stylix.nixosModules.stylix
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        # proxmox-nixos.nixosModules.proxmox-ve
        hyprdynamicmonitors.nixosModules.default
        nix-index-database.nixosModules.default
      ];
    in
    {

      ########
      ## Pc ##
      ########

      nixosConfigurations = {
        "pc" = nixpkgs.lib.nixosSystem {
          specialArgs = commonArgs;
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.extraSpecialArgs = commonArgs;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${usrConfig.username} = import ./config/pc/hm-main-pc.nix;
              };
            }
            ./hosts/pc/pc-nix-main.nix
          ] ++ commonNixModules;
        };
      };


      ############
      ## Laptop ##
      ############

      nixosConfigurations = {
        "laptop" = nixpkgs.lib.nixosSystem {
          specialArgs = commonArgs;
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.extraSpecialArgs = commonArgs;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${usrConfig.username} = import ./config/laptop/hm-main-laptop.nix;
              };
            }
            nixos-hardware.nixosModules.framework-13-7040-amd
            ./hosts/laptop/laptop-hm-main.nix
          ] ++ commonNixModules;
        };
      };
    };
}
