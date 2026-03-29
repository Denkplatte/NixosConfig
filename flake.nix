{
  description = "Clean NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    home-manager.url = "github:nix-community/25.11";
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
        {
          home-manager.users."las" = import ./home/default.nix;
        }
      ];
    };
  };
}
