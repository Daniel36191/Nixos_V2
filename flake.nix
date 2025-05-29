{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-spotifyOld.url = "github:nixos/nixpkgs/6eb01a67e1fc558644daed33eaeb937145e17696";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    blender-cuda.url = "github:edolstra/nix-warez?dir=blender"; ## Blender-bin (now with cuda)
    lemonake.url = "github:passivelemon/lemonake";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland";
  };

  outputs = {
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      nixpkgs-xr,
      blender-cuda,
      lemonake,
      chaotic,
      nixpkgs-spotifyOld,
      split-monitor-workspaces,
      ...
  }@inputs:
    let
        inherit (import ./config/variables.nix)
            system
            host
            username
            ;
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
	          inherit system;
            inherit inputs;
            inherit username;
            inherit host;

            ## Pinning Nixpkgs versions
            pkgs-spotifyOld = import nixpkgs-spotifyOld {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${username} = import ./config/hm-main.nix;
              };
            }
            ./config/nix-main.nix
            inputs.stylix.nixosModules.stylix
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            nixpkgs-xr.nixosModules.nixpkgs-xr
            chaotic.nixosModules.default
          ];
        };
      };
    };
}
