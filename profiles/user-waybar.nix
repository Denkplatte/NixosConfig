{ config, lib, pkgs, ... }:

let
  # ==============================================================
  # Figlet image generator script
  # ==============================================================
  figletImageScript = pkgs.writeShellScriptBin "generate-figlet-image" ''
    #!${pkgs.bash}/bin/bash
    mkdir -p ~/.config/waybar/images

    ${pkgs.figlet}/bin/figlet -f cricket "[ ! ]" | \
      ${pkgs.imagemagick}/bin/convert -background transparent \
      -fill "#4ec9b0" \
      -font "DejaVu-Sans-Mono" \
      -pointsize 14 \
      label:@- \
      ~/.config/waybar/images/nixos-figlet.png

    echo "Figlet image created at ~/.config/waybar/images/nixos-figlet.png"
  '';
in {
  home.packages = with pkgs; [
    figlet
    imagemagick
    figletImageScript
  ];

  # ==============================================================
  # Battery ASCII script
  # ==============================================================
  home.file."/.config/waybar/battery-bar.sh" = {
    text = ''
      #!/usr/bin/env bash
      BATTERY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "?")
      CHARGING=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null | grep -q "Charging" && echo "+" || echo "")

      INTERIOR_WIDTH=14
      FILLED_WIDTH=$(( BATTERY * INTERIOR_WIDTH / 100 ))

      FILLED=""
      for ((i=0; i<$FILLED_WIDTH; i++)); do FILLED="''${FILLED}█"; done

      EMPTY=""
      for ((i=$FILLED_WIDTH; i<$INTERIOR_WIDTH; i++)); do EMPTY="''${EMPTY}░"; done
      EMPTY="''${EMPTY} "

      LINE1="   ╔══════════════╗   "
      LINE2="   ║''${FILLED}''${EMPTY}║''${CHARGING}   "
      LINE3="   ╚══════════════╝   "

      BATTERY_DISPLAY="''${LINE1}\n''${LINE2}\n''${LINE3}"

      echo "{\"text\": \"''${BATTERY_DISPLAY}\", \"tooltip\": \"Battery: ''${BATTERY}%\"}"
    '';
    executable = true;
  };

  # ==============================================================
  # Volume ASCII script (clamped to 100%)
  # ==============================================================
  home.file."/.config/waybar/volume-bar.sh" = {
    text = ''
      #!/usr/bin/env bash
      VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

      if [ "$VOLUME" -gt 100 ]; then
          VOLUME=100
      fi

      TOTAL_BLOCKS=20
      FILLED=$(( VOLUME * TOTAL_BLOCKS / 100 ))
      EMPTY=$(( TOTAL_BLOCKS - FILLED ))

      FILLED_BAR=""
      for ((i=0; i<$FILLED; i++)); do FILLED_BAR="''${FILLED_BAR}#"; done

      EMPTY_BAR=""
      for ((i=0; i<$EMPTY; i++)); do EMPTY_BAR="''${EMPTY_BAR}-"; done

      BAR="[''${FILLED_BAR}''${EMPTY_BAR}]"

      echo "{\"text\": \"$BAR\", \"tooltip\": \"Volume: $VOLUME%\"}"
    '';
    executable = true;
  };

  # ==============================================================
  # Wi-Fi ASCII + SSID inline
  # ==============================================================
  home.file."/.config/waybar/wifi-bar.sh" = {
    text = ''
      #!/usr/bin/env bash
      ESSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
      SIGNAL=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d: -f2)

      if [ -z "$SIGNAL" ]; then
          SIGNAL=0
      fi

      INTERIOR_WIDTH=10
      FILLED_WIDTH=$(( SIGNAL * INTERIOR_WIDTH / 100 ))

      FILLED=""
      for ((i=0; i<$FILLED_WIDTH; i++)); do FILLED="''${FILLED}█"; done

      EMPTY=""
      for ((i=$FILLED_WIDTH; i<$INTERIOR_WIDTH; i++)); do EMPTY="''${EMPTY}░"; done

      LINE1="   ╔══════════╗   "
      LINE2="   ║''${FILLED}''${EMPTY}║   "
      LINE3="   ╚══════════╝   "

      WIFI_DISPLAY="''${LINE1}\n''${LINE2}\n''${LINE3}"

      echo "{\"text\": \"''${WIFI_DISPLAY}\", \"tooltip\": \"Wi-Fi: ''${ESSID} (''${SIGNAL}%)\"}"
    '';
    executable = true;
  };
  # ==============================================================
  # CPU sparkline
  # ==============================================================
  home.file."/.config/waybar/cpu-spark.sh" = {
    text = ''
      #!/usr/bin/env bash
      FILE="/tmp/cpu-spark"
      MAXLEN=10

      read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
      total=$((user+nice+system+idle+iowait+irq+softirq+steal))
      idle_all=$((idle+iowait))

      if [ -f "$FILE.prev" ]; then
        read -r prev_total prev_idle < "$FILE.prev"
        diff_total=$((total - prev_total))
        diff_idle=$((idle_all - prev_idle))
        usage=$(( (100*(diff_total-diff_idle)) / diff_total ))
      else
        usage=0
      fi

      echo "$total $idle_all" > "$FILE.prev"

      if   [ "$usage" -lt 25 ]; then dot="_"
      elif [ "$usage" -lt 50 ]; then dot="."
      elif [ "$usage" -lt 75 ]; then dot=":"
      else dot="░"
      fi

      history=$(cat "$FILE" 2>/dev/null || echo "")
      history="$history$dot"
      history=$(echo "$history" | tail -c $MAXLEN)

      echo "$history" > "$FILE"

      echo "{\"text\": \"CPU: $usage% $history\", \"tooltip\": \"CPU Usage: $usage%\"}"
    '';
    executable = true;
  };

  # ==============================================================
  # Memory simple percentage
  # ==============================================================
  home.file."/.config/waybar/memory.sh" = {
    text = ''
      #!/usr/bin/env bash
      mem=$(free | awk '/Mem:/ {print int($3/$2 * 100)}')
      echo "{\"text\": \" $mem%\", \"tooltip\": \"Memory Usage: $mem%\"}"
    '';
    executable = true;
  };

  # ==============================================================
  # Disk simple percentage
  # ==============================================================
  home.file."/.config/waybar/disk.sh" = {
    text = ''
      #!/usr/bin/env bash
      disk=$(df / | awk 'END {print int($3/$2 * 100)}')
      echo "{\"text\": \" $disk%\", \"tooltip\": \"Disk Usage: $disk%\"}"
    '';
    executable = true;
  };

  # ==============================================================
  # Waybar main config
  # ==============================================================
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      @import url("${config.home.homeDirectory}/.cache/wal/colors-waybar.css");

      * {
        font-family: "Terminus", "Font Awesome 5 Free", monospace;
        font-size: 10px;
        min-height: 20px;
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

      #clock, #custom-battery, #custom-cpu, #custom-disk, #custom-memory, #custom-wifi, #pulseaudio, #tray, #mode {
        padding: 0 10px;
        margin: 0 4px;
      }

      #custom-nixos {
        background-image:url('/home/las/.config/waybar/images/nixos-figlet.png');
        background-position: left center;
        background-repeat: no-repeat;
        background-size: contain;
        min-width: 30px;
      }

     tooltip {
       background: #000000;
       color: #ffffff;
      }

 


      #custom-volume-bar { color: @color2; }
      #custom-battery { color: @color4; }
      #custom-wifi { color: @color6; }

      /* spacing tweaks */
      
     /*#custom-battery { margin-left: 20px; }*/
     #custom-volume-bar {margin-right: 20px;}
     '';	

    settings = [{
      layer = "top";
      position = "top";
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;

      height = 20;
      spacing = 4;
    

      modules-left = [
        "custom/nixos"
        "niri/workspaces"
        "clock"
        "wlr/taskbar"
      ];

      modules-right = [
        "custom/cpu"
        "custom/memory"
        "custom/disk"
        "custom/wifi"
        "custom/battery"
        "pulseaudio"
        "tray"
        "custom/volume-bar"
      ];
      
     "wlr/taskbar" = {
        "on-click" = "activate";
      };

      "custom/nixos" = {
        format = " ";
        tooltip = false;
      };

      "custom/battery" = {
        exec ="~/.config/waybar/battery-bar.sh";
        interval= 30;
        return-type = "json";
      };

      "custom/volume-bar" = {
        exec ="~/.config/waybar/volume-bar.sh";
        interval= 2;
        return-type = "json";
      };

      "custom/wifi" = {
        exec ="~/.config/waybar/wifi-bar.sh";
        interval= 10;
        return-type = "json";
      };

      "custom/cpu" = {
        exec ="~/.config/waybar/cpu-spark.sh";
        interval= 2;
        return-type = "json";
      };

      "custom/memory" = {
        exec ="~/.config/waybar/memory.sh";
        interval= 5;
        return-type = "json";
      };

      "custom/disk" = {
        exec ="~/.config/waybar/disk.sh";
        interval= 20;
        return-type = "json";
      };
    }];
  };

  # ==============================================================
  # Extra setup (images + pywal template)
  # ==============================================================
  home.file.".config/waybar/images/.keep".text = "";

  home.activation.generateFigletImage = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.config/waybar/images
    $DRY_RUN_CMD ${pkgs.figlet}/bin/figlet -f cricket "[ ! ]" | \
      $DRY_RUN_CMD ${pkgs.imagemagick}/bin/convert -background transparent \
      -fill "#4ec9b0" \
      -font "DejaVu-Sans-Mono" \
      -pointsize 14 \
      label:@- \
      ~/.config/waybar/images/nixos-figlet.png || true
  '';

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
