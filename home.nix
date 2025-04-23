{ config, pkgs, ... }:

{
  # Home Manager needs this to be set
  home.username = "las";
  home.homeDirectory = "/home/las";
  
  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Packages just for your user
  home.packages = with pkgs; [
    firefox
    vscode
    blender
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
      font.size = 11.0;
      window.opacity = 0.95;
    };
  };

  # Don't change this after first install
  home.stateVersion = "24.11";
}
