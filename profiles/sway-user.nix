{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      
      # Use stacking layout by default (more like a traditional WM)
      workspaceLayout = "tabbed";
      
      bars = [];  # No default bar since we use waybar
    };
    extraConfig = ''
      # Additional Sway configuration
      default_border pixel 2
      
      # For a more TUI-like appearance:
      font pango:Terminus 11
    '';
  };
  
  # Add waybar
  programs.waybar = {
    enable = true;
    style = ''
      /* TUI-inspired waybar styling */
      * {
        border: none;
        font-family: Terminus, monospace;
        font-size: 12px;
        color: #ffffff;
        background: #000000;
      }
      
      window#waybar {
        background-color: #000000;
        color: #ffffff;
        border-bottom: 1px solid #00ff00;
      }
      
      /* More styling as needed */
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = ["sway/workspaces" "sway/mode"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "battery" "tray"];
      };
    };
  };
  
  # Additional packages for the user
  home.packages = with pkgs; [
    wofi
    grim  # Screenshot
    slurp # Screen area selection
  ];
}
