{ pkgs, ... }:

let
  t = import ../../theme/hotline-miami.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = ''
      * {
        font-family: "Terminus", "Font Awesome 5 Free", monospace;
        font-size: 11px;
        min-height: 20px;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: ${t.bgAlt};
        border-bottom: 1px solid ${t.pinkDim};
        color: ${t.fg};
      }

      #workspaces button {
        padding: 0 10px;
        color: ${t.fgMuted};
        background: transparent;
        border-bottom: 2px solid transparent;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: ${t.pink};
        border-bottom: 2px solid ${t.pink};
      }

      #workspaces button:hover {
        color: ${t.cyan};
        border-bottom: 2px solid ${t.cyan};
      }

      #clock {
        color: ${t.cyan};
        padding: 0 12px;
        border-left: 1px solid ${t.pinkDim};
      }

      #cpu { color: ${t.orange}; padding: 0 10px; }
      #memory { color: ${t.yellow}; padding: 0 10px; }
      #disk { color: ${t.fgMuted}; padding: 0 10px; }

      #network {
        color: ${t.cyan};
        padding: 0 10px;
      }

      #pulseaudio {
        color: ${t.pink};
        padding: 0 10px;
      }

      #pulseaudio.muted {
        color: ${t.fgMuted};
      }

      #battery {
        color: ${t.yellow};
        padding: 0 10px;
      }

      #battery.charging { color: ${t.cyan}; }
      #battery.critical:not(.charging) { color: ${t.pink}; }

      #tray {
        padding: 0 8px;
        border-left: 1px solid ${t.pinkDim};
      }

      #custom-launcher {
        color: ${t.pink};
        padding: 0 14px;
        font-size: 13px;
        border-right: 1px solid ${t.pinkDim};
      }

      #custom-launcher:hover { color: ${t.cyan}; }

      tooltip {
        background: ${t.bgAlt};
        border: 1px solid ${t.pinkDim};
        color: ${t.fg};
      }
    '';

    settings = [{
      layer = "top";
      position = "top";
      height = 22;
      exclusive = true;

      modules-left = [
        "custom/launcher"
        "wlr/taskbar"
      ];

      modules-center = [ "clock" ];

      modules-right = [
        "cpu"
        "memory"
        "network"
        "battery"
        "pulseaudio"
        "tray"
      ];

      "custom/launcher" = {
        format = "[ ! ]";
        on-click = "kitty --class fsel -e fsel";
        tooltip = false;
      };

      "wlr/taskbar" = {
        on-click = "activate";
        on-click-middle = "close";
        format = "{name}";
        max-length = 20;
      };

      clock = {
        format = " {:%H:%M}";
        format-alt = " {:%Y-%m-%d %H:%M}";
        tooltip-format = "{:%A, %B %d %Y}";
      };

      cpu = {
        format = " {usage}%";
        tooltip = false;
        interval = 2;
      };

      memory = {
        format = " {}%";
        interval = 5;
      };

      network = {
        format-wifi = " {essid}";
        format-ethernet = " {ifname}";
        format-disconnected = " --";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      battery = {
        states = { warning = 30; critical = 15; };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = " muted";
        format-icons = {
          default = [ "" "" "" ];
        };
        on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        scroll-step = 5;
      };

      tray = {
        icon-size = 14;
        spacing = 8;
      };
    }];
  };
}
