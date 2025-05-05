{
  description = "Basic NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    newm-atha.url = "sourcehut:~atha/newm-atha";
  };

  outputs = { self, nixpkgs, home-manager, newm-atha, ... }: {
    nixosConfigurations.Denkplatte = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./modules/fonts.nix
        ./modules/hyprland
        ./modules/newm-wrapper.nix
        {
          _module.args = {
            newm-atha = newm-atha;
          };
        }
        ({ pkgs, ... }: {
          environment.systemPackages = [
            newm-atha.packages.${pkgs.system}.newm-atha
          ];
          environment.pathsToLink = [ "/bin" ];
        })
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.las = import ./home.nix;
        }
      ];
    };
  };
}
