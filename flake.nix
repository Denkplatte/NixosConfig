{
	description = "Basic NixOS Config";
	
	inputs = {
		#Core package sources
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

	# Home Manager
	home-manager = {
		url = "github:nix-community/home-manager/release-24.11";
		inputs.nixpkgs.follows = "nixpkgs";
	};
};

outputs = {self, nixpkgs, home-manager, ...}: {
	nixosConfigurations.Denkplatte = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			./configuration.nix
			./modules/fonts.nix
			#./modules/sway
			./modules/hyprland

			home-manager.nixosModules.home-manager {
			 home-manager.useGlobalPkgs = true;
	 		 home-manager.useUserPackages = true;
			 home-manager.users.las = { ... } : {
				 imports = [ 
					./home.nix
					#./profiles/sway-user.nix
					./profiles/user-hyprland.nix
					];
				};
			}
		];
	};
};
}		
