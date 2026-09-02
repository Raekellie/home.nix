{
  description = "My lovely machines under Nix :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    sops-nix,
    impermanence,
    ...
  } @ inputs: let
    # May also be used to pass over arguments to the regular `pkgs` if necessary, in the same way as done below for `nixpkgs-unstable`
    pkg-args = {
      system = "x86_64-linux";
    };
    # While `pkgs` is is special and taken care of by nixosConfigurations, any alternative has to be dealt with manually
    pkgs-unstable = import nixpkgs-unstable pkg-args;
  in {
    packages.${pkg-args.system}."live-image" = self.nixosConfigurations."live-image".config.system.build.isoImage;

    nixosConfigurations = {
      "deskel" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };

        modules = [
          ./sops/system.nix
          ./hosts/deskel

          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
              ./sops/home.nix
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."raquel" = ./home/raquel.nix;

            home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ];
      };

      "live-image" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
        inherit (pkg-args) system;

        modules = [
          ./hosts/live-image

          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
              ./sops/home.nix
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."nixos" = ./home/common.nix;

            home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ];
      };
    };
  };
}
