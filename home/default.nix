{pkgs, ... }:

{
  home.username = "las";
  home.homeDirectory = "/home/las";
  home.stateVersion = "25.11";
  xdg.enable = true;


  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };

  imports = [
	./modules/user-mimeapps.nix
	./modules/figletfonts.nix
	./programs/power-menu.nix
        #./programs/fsel.nix
	./programs/kitty.nix
	./programs/waybar.nix
	./programs/superfile.nix
	./programs/driftwm.nix
	#./programs/fsel-dmenu.nix
	./programs/yazi.nix
        #./programs/tofi.nix
	./programs/fzf-launcher.nix
	./desktop-entries.nix
  ];

}
