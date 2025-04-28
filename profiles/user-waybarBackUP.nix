{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: "Iosevka Term", monospace;
        font-size: 12px;
        min-height: 0;
        color: #3de163;
        background: #111111;
      }

      window#waybar {
        background: #000000;
        border-bottom: 2px solid #3de163;
      }

      #workspaces button {
        padding: 0 8px;
        color: #3de163;
        border: none;
        border-right: 1px solid #3de163;
      }

      #workspaces button.focused {
        background: #3de163;
        color: #000000;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-weather, #tray, #mode {
        padding: 0 8px;
        margin: 0px 2px;
        border: 1px solid #3de163;
      }

      #custom-separator {
        color: #3de163;
        padding: 0 4px;
      }

      #custom-ascii-art {
        padding: 0 8px;
        color: #3de163;
      }
    '';

    settings = [{
      layer = "top";
      position = "top";
      height = 24;
      modules-left = [
        "custom/ascii-art"
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

      "custom/ascii-art" = {
        exec = "echo '▓▒░ [!]  ░▒▓'";
        interval = "once";
        format = "{}";
      };

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
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
        format = "CPU {usage}%";
        tooltip = false;
      };

      memory = {
        format = "MEM {}%";
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = ["" "" "" "" ""];
      };

      network = {
        format-wifi = "直 {essid}";
        format-ethernet = " {ifname}";
        format-linked = " {ifname}";
        format-disconnected = "睊";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "{icon} {volume}%";
        format-bluetooth-muted = " {icon}";
        format-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };

      tray = {
        icon-size = 16;
        spacing = 8;
      };
    }];
  };

  # Add the matching greetd configuration with retro ASCII art
#  services.greetd = {
#    enable = true;
#    settings = {
#      default_session = {
#        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
#        user = "greeter";
#      };
#    };
#  };

  # Install supporting packages
#  environment.systemPackages = with pkgs; [
#    (nerdfonts.override { fonts = [ "Iosevka" ]; })
#    figlet
#    lolcat
#  ];

  # Optional: Custom ASCII login message for terminal
  programs.bash.loginShellInit = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
      echo -e "\033[32m"
      figlet -f small "NixOS Terminal" | lolcat
      echo -e "\033[0m"
    fi
  '';
}
