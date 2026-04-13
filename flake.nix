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
    pkgs = nixpkgs.legacyPackages.${system};
    neuwld = pkgs.callPackage ./home/builds/neuwld.nix {};
    neuswc = pkgs.callPackage ./home/builds/neuswc.nix { inherit neuwld; };
    hevel = pkgs.callPackage ./home/builds/hevel.nix {inherit neuwld neuswc; };  # <-- this is the only new line
  in {
    nixosConfigurations.Denkplatte = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/Denkplatte/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users."las" = import ./home/default.nix;
        }
        ({ ... }: {                               # <-- add hevel to packages
          environment.systemPackages = [ hevel ];
        })
      ];
    };
  };
}
