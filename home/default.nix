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
       	./programs/kitty.nix
	./programs/waybar.nix
	./programs/superfile.nix
	./programs/driftwm.nix
	./programs/yazi.nix
	./programs/fzf-launcher.nix
	./desktop-entries.nix
  ];

}
