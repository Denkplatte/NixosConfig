{
  description = "Clean NixOS config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fsel.url = "github:Mjoyufull/fsel";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.Denkplatte = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/Denkplatte/configuration.nix
        home-manager.nixosModules.home-manager
        { home-manager.users."las" = import ./home/default.nix; }
      ];
    };
  };
}

