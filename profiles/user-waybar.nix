{ config, lib, pkgs, ... }:

let
  # Define the script as a derivation for image generation
  figletImageScript = pkgs.writeShellScriptBin "generate-figlet-image" ''
    #!${pkgs.bash}/bin/bash
    
    # Create directory for the image if it doesn't exist
    mkdir -p ~/.config/waybar/images
    
    # Generate figlet output, convert to image, and save
    ${pkgs.figlet}/bin/figlet -f cricket "[ ! ]" | \
      ${pkgs.imagemagick}/bin/convert -background transparent \
      -fill "#4ec9b0" \
      -font "DejaVu-Sans-Mono" \
      -pointsize 14 \
      label:@- \
      ~/.config/waybar/images/nixos-figlet.png
      
    echo "Figlet image created at ~/.config/waybar/images/nixos-figlet.png"
  '';
in
{
  home.packages = with pkgs; [
    figlet
    imagemagick
    figletImageScript
  ];
  
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      /* Import pywal colors */
      @import url("${config.home.homeDirectory}/.cache/wal/colors-waybar.css");
      * {
        font-family: "Terminus", "Font Awesome 5 Free", monospace;
        font-size: 13px;
        min-height: 40px;
        color: @foreground;
        background: transparent;
      }
      window#waybar {
        background: @background;
        border-bottom: 2px solid @color2;
      }
      #workspaces button {
        padding: 0 8px;
        color: @color7;
        margin: 0 2px;
      }
      #workspaces button.focused {
        background: @color2;
        color: @background;
      }
      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode {
        padding: 0 10px;
        margin: 0 4px;
      }
      /* Special styling for figlet image module using background-image */
      #custom-nixos {
        background-image:url('/home/las/.config/waybar/images/LOGOAINegative.png');
        background-position: left;
        background-repeat: no-repeat;
        background-size: contain;
      }
      #battery.charging {
        color: @color4;
      }
      #battery.warning:not(.charging) {
        color: @color3;
      }
      #battery.critical:not(.charging) {
        color: @color1;
        animation: blink 1s linear infinite;
      }
      @keyframes blink {
        to {
          color: @background;
        }
      }
    '';
    
    settings = [{
      layer = "top";
      position = "top";

      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;

      height = 30;
      spacing = 4;
      modules-left = [
        "custom/nixos"
        "hyprland/workspaces"
      ];
      modules-center = ["clock"];
      modules-right = [
        "cpu"
        "memory"
        "network"
        "battery"
        "pulseaudio"
        "tray"
      ];
      
      "custom/nixos" = {
        # Empty format since we're using CSS background image
        format = "                                                                           ";
        tooltip = false;
      };
      
      # Rest of your configuration remains the same
      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "一";
          "2" = "二";
          "3" = "三";
          "4" = "四";
          "5" = "五";
          "urgent" = "!";
          "focused" = "";
          "default" = "";
        };
      };
      clock = {
        format = "  {:%H:%M} ";
        format-alt = "  {:%Y-%m-%d} ";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      cpu = {
        format = "  {usage}%";
        tooltip = false;
        interval = 1;
      };
      memory = {
        format = "  {}%";
        interval = 5;
      };
      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%";
        format-plugged = "  {capacity}%";
        format-alt = "{icon}  {time}";
        format-icons = ["" "" "" "" ""];
        interval = 10;
      };
      network = {
        format-wifi = "  {essid} ({signalStrength}%)";
        format-ethernet = "  {ifname}: {ipaddr}";
        format-linked = "  {ifname} (No IP)";
        format-disconnected = "  Disconnected";
        format-alt = "  {bandwidthUpBits} |  {bandwidthDownBits}";
        interval = 5;
      };
      pulseaudio = {
        format = "{icon}  {volume}%";
        format-bluetooth = "  {volume}%";
        format-bluetooth-muted = "  Muted";
        format-muted = "  Muted";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      tray = {
        icon-size = 16;
        spacing = 8;
      };
    }];
  };
  
  # Create a directory for waybar images
  home.file.".config/waybar/images/.keep".text = "";
  
  # Make sure the image is generated during activation
  home.activation.generateFigletImage = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.config/waybar/images
    # Generate the image directly here
    $DRY_RUN_CMD ${pkgs.figlet}/bin/figlet -f cricket "[ ! ]" | \
      $DRY_RUN_CMD ${pkgs.imagemagick}/bin/convert -background transparent \
      -fill "#4ec9b0" \
      -font "DejaVu-Sans-Mono" \
      -pointsize 14 \
      label:@- \
      ~/.config/waybar/images/nixos-figlet.png || true
  '';
  
  # Your pywal template configuration remains the same
  home.file.".config/wal/templates/colors-waybar.css".text = ''
    @define-color foreground {{foreground}};
    @define-color background {{background}};
    @define-color cursor {{cursor}};
    @define-color color0 {{color0}};
    @define-color color1 {{color1}};
    @define-color color2 {{color2}};
    @define-color color3 {{color3}};
    @define-color color4 {{color4}};
    @define-color color5 {{color5}};
    @define-color color6 {{color6}};
    @define-color color7 {{color7}};
    @define-color color8 {{color8}};
    @define-color color9 {{color9}};
    @define-color color10 {{color10}};
    @define-color color11 {{color11}};
    @define-color color12 {{color12}};
    @define-color color13 {{color13}};
    @define-color color14 {{color14}};
    @define-color color15 {{color15}};
  '';
  
  home.activation.waybarPywalInit = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f ${config.home.homeDirectory}/.cache/wal/colors-waybar.css ]; then
      mkdir -p ${config.home.homeDirectory}/.cache/wal
      ${pkgs.python3Packages.pywal}/bin/wal -i ${config.home.homeDirectory}/wallpapers/current.jpg -n
    fi
  '';
}
