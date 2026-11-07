{
  description = "Clean NixOS config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # Unstable branch
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    driftwm = {
	url = "github:malbiruk/driftwm";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable , home-manager, driftwm, ... }:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        };
  in {
    nixosConfigurations.Denkplatte = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs-unstable; };
      modules = [
        ./hosts/Denkplatte/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."las" = import ./home/default.nix;
   
        }
        ({pkgs, ... }:{
          environment.systemPackages = [
            driftwm.packages.${system}.default
          ];
          services.displayManager.sessionPackages = [
            driftwm.packages.${system}.default
          ];
        })
      ];
    };
  };
}

