{
  description = "My lovely machines under Nix :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:Raekellie/dotfiles";
      flake = false;
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
          #system = "x86-64-linux";
          specialArgs = { inherit inputs; };

          modules = [
            ./core
            ./desktop
            ./hosts/nixos/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."raquel" = ./home/raquel.nix;

              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };
    };
}
