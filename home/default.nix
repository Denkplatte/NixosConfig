{ ... }:

{
  home.username = "las";
  home.homeDirectory = "/home/las";

  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };

  imports = [
	./modules/user-mimeapps.nix
	./modules/power-menu.nix
        ./builds/fsel.nix
	./programs/kitty.nix
	./programs/waybar.nix
	./programs/superfile.nix
	./programs/driftwm.nix
  ];

}
