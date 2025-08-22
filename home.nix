{ config, pkgs, ... }:

{
  # Home Manager needs this to be set
  home.username = "las";
  home.homeDirectory = "/home/las";
  
  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  xdg.desktopEntries.houdini = {
    name = "Houdini Apprentice";
    exec = "/home/las/Downloads/result/bin/houdini %U";
    terminal = false;
    type = "Application";
    icon = "/home/las/Downloads/Houdini3D_icon.png";
    
  };


  # Packages just for your user
  home.packages = with pkgs; [
    bemenu
    kitty
    wl-clipboard
    xdg-utils
    brightnessctl
    wezterm
    firefox
    vscode
    blender
    pywal
    spotify-player
    libreoffice
    	
    
  ];

  # Git configuration
#  programs.git = {
#    enable = true;
#    userName = "Your Name";
#    userEmail = "your.email@example.com";
#    extraConfig = {
#      init.defaultBranch = "main";
#    };
#  };

  # Terminal configuration
#  programs.bash = {
#   enable = true;
#    shellAliases = {
#      ll = "ls -la";
#      ".." = "cd ..";
#      update = "sudo nixos-rebuild switch --flake /path/to/nixos-config#mycomputer";
#    };
#    bashrcExtra = ''
#      export PATH="$HOME/.local/bin:$PATH"
#    '';
#  };

  # If you want to use Alacritty terminal
  programs.alacritty = {
    enable = true;
    settings = {

      window.decorations = "None";
      
      window.opacity = 0.95;
	font = {
	  normal = {
            family = "Terminus";
            style = "Regular";
	};
	  bold = {
	    family = "Terminus";
	    style = "Bold";
	};
	  italic = {
	    family = "Terminus";
            style = "Italic";
	};	
      };
    };
  };

  #home.file.".config/waybar/volume-bar.sh".source = ./scripts/volume-bar.sh;


  imports = [
    #./profiles/user-hyprland.nix
    ./profiles/user-waybar.nix
    #./profiles/user-newm.nix
  ];


  # Don't change this after first install
  home.stateVersion = "25.05";
}
