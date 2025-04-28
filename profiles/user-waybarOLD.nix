{ config, lib, pkgs, ... }:

{
  # This is a Home Manager module, so we need to use home.packages instead of environment.systemPackages
  home.packages = with pkgs; [
   # terminus_font
   # figlet
   # lolcat
   # python3Packages.pywal
    # Create the helper script
    (pkgs.writeShellScriptBin "figlet-waybar" ''
      ${pkgs.figlet}/bin/figlet -f small "NixOS" | head -n1
    '')
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
        min-height: 0;
        /* Use pywal colors */
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

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-weather, #tray, #mode, #custom-figlet {
        padding: 0 10px;
        margin: 0 4px;
        /* No boxes around modules */
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

      #custom-figlet {
        font-family: "monospace";
        color: @color2;
      }

      /* Gradient effect */
      #custom-ascii-art {
        background: linear-gradient(90deg, 
                                   @color1 0%, 
                                   @color2 25%, 
                                   @color3 50%, 
                                   @color4 75%, 
                                   @color5 100%);
        background-clip: text;
        -webkit-background-clip: text;
        color: transparent;
        padding: 0 10px;
        font-weight: bold;
        text-shadow: 0 0 2px rgba(0,0,0,0.5);
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
      height = 30;
      spacing = 4;
      modules-left = [
        "custom/figlet"
        "sway/workspaces"
        "sway/mode"
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

      "custom/figlet" = {
        exec = "${pkgs.bash}/bin/bash -c '${pkgs.figlet}/bin/figlet -f small \"NixOS\" | head -n1'";
        interval = "once";
        format = "{}";
      };

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

  # Setup pywal
  programs.bash = {
    enable = true;
    initExtra = ''
      # Generate and apply pywal theme on login
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        wal -i ${config.home.homeDirectory}/wallpapers/current.jpg -n
      fi
    '';
  };

  # Create pywal template for waybar
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

  # In Home Manager we use home.activation instead of system.activationScripts
  home.activation.pywalInit = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f ${config.home.homeDirectory}/.cache/wal/colors-waybar.css ]; then
      mkdir -p ${config.home.homeDirectory}/.cache/wal
      ${pkgs.python3Packages.pywal}/bin/wal -i ${config.home.homeDirectory}/wallpapers/current.jpg -n
    fi
  '';
}
