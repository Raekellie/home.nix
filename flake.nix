{
  description = "My lovely machines under Nix :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86-64-linux";
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/nixos/configuration.nix
            ./modules/system/shell.nix
            ./modules/system/desktop.nix
            ./modules/system/art.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."raquel" = ./modules/user/raquel.nix;

              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };
    };
  }
