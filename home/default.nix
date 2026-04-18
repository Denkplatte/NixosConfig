{ ... }:

{
  home.username = "las";
  home.homeDirectory = "/home/las";

  home.stateVersion = "25.11";

  imports = [
	./modules/user-packages.nix
	./builds/otter-launcher.nix
        ./builds/fsel.nix
	./programs/kitty.nix
	./programs/waybar.nix
	./programs/superfile.nix
  ];

}
