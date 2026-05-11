{
  description = "My lovely machines under Nix :3";

  inputs = {
    # Temporarily set to unstable to have the stateVersion be 26.05 (releasing in a few weeks)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      #url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
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
      sops-nix,
      impermanence,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          #system = "x86-64-linux";
          specialArgs = { inherit inputs; };

          modules = [
            #sops-nix.nixosModules.sops # Currently seeing how loading it after feels in terms of cleanliness
            impermanence.nixosModules.impermanence
            ./hosts/nixos

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
