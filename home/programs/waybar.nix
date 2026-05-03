{ pkgs, lib, config, ... }:

let
  t = import ../../theme/hotline-miami.nix;
in
{
  # --- script files ---
 home.file."/.config/waybar/battery-bar.sh" = {
  text = ''
    #!/usr/bin/env bash
    BATTERY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "?")
    STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")
    echo "$STATUS" | grep -q "Charging" && CHARGING="⚡" || CHARGING=""

    INTERIOR_WIDTH=10
    FILLED_WIDTH=$(( BATTERY * INTERIOR_WIDTH / 100 ))

    FILLED=""
    for ((i=0; i<$FILLED_WIDTH; i++)); do FILLED="''${FILLED}█"; done

    EMPTY=""
    for ((i=$FILLED_WIDTH; i<$INTERIOR_WIDTH; i++)); do EMPTY="''${EMPTY}░"; done

    LINE1="   ╔══════════╗"
    LINE2="   ║''${FILLED}''${EMPTY}║║''${CHARGING}"
    LINE3="   ╚══════════╝"

    echo "{\"text\": \"''${LINE1}\n''${LINE2}\n''${LINE3}\", \"tooltip\": \"Battery: ''${BATTERY}% (''${STATUS})\"}"
  '';
  executable = true;
};


home.file."/.config/waybar/volume-bar.sh" = {
  text = ''
    #!/usr/bin/env bash
    RAW=$(LC_ALL=C wpctl get-volume @DEFAULT_AUDIO_SINK@)
    MUTED=$(echo "$RAW" | grep -q MUTED && echo "1" || echo "0")
    VOLUME=$(echo "$RAW" | awk '{printf "%d", $2 * 100}')

    if [ "$VOLUME" -gt 100 ]; then
        VOLUME=100
    fi

    # treat volume=0 as muted too
    if [ "$MUTED" = "1" ] || [ "$VOLUME" -eq 0 ]; then
      ICON="󰖁"
      BAR="[--------------------] MUTE"
      TOOLTIP="Volume: muted"
    else
      TOTAL_BLOCKS=20
      FILLED=$(( VOLUME * TOTAL_BLOCKS / 100 ))
      EMPTY=$(( TOTAL_BLOCKS - FILLED ))

      FILLED_BAR=""
      for ((i=0; i<FILLED; i++)); do FILLED_BAR="''${FILLED_BAR}#"; done

      EMPTY_BAR=""
      for ((i=0; i<EMPTY; i++)); do EMPTY_BAR="''${EMPTY_BAR}-"; done

      ICON="󰖀"
      BAR="[''${FILLED_BAR}''${EMPTY_BAR}] ''${VOLUME}%"
      TOOLTIP="Volume: ''${VOLUME}%"
    fi

    echo "{\"text\": \"''${ICON} ''${BAR}\", \"tooltip\": \"''${TOOLTIP}\"}"
  '';
  executable = true;
};

systemd.user.services.waybar-volume-watcher = {
  Unit = {
    Description = "PipeWire volume event watcher for Waybar";
    After = [ "pipewire.service" "waybar.service" ];
    PartOf = [ "graphical-session.target" ];
  };
  Service = {
    ExecStart = "%h/.config/waybar/volume-watcher.sh";
    Restart = "on-failure";
    RestartSec = "2s";
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};

home.activation.startWatcher = lib.hm.dag.entryAfter ["writeBoundary"] ''
  systemctl --user enable --now waybar-volume-watcher.service || true
'';


home.file."/.config/waybar/volume-watcher.sh" = {
  text = ''
    #!/usr/bin/env bash
    # Watches PipeWire for volume/mute changes and signals waybar.
    # pactl subscribe gives us a stream of events like:
    #   Event 'change' on sink #0
    # We filter for sink events (which cover volume + mute).
    pactl subscribe 2>/dev/null | grep --line-buffered "sink" | while read -r _; do
      pkill -SIGRTMIN+8 waybar
    done
  '';
  executable = true;
};


home.file."/.config/waybar/wifi-bar.sh" = {
  text = ''
    #!/usr/bin/env bash
    ESSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
    SIGNAL=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d: -f2)

    if [ -z "$SIGNAL" ]; then
        SIGNAL=0
        ESSID="disconnected"
    fi

    BAR1=$([ "$SIGNAL" -ge 20 ] && echo "▂" || echo "░")
    BAR2=$([ "$SIGNAL" -ge 40 ] && echo "▃" || echo "░")
    BAR3=$([ "$SIGNAL" -ge 60 ] && echo "▅" || echo "░")
    BAR4=$([ "$SIGNAL" -ge 80 ] && echo "▆" || echo "░")
    BAR5=$([ "$SIGNAL" -ge 95 ] && echo "█" || echo "░")

    BARS="\uf1eb ''${BAR1}''${BAR2}''${BAR3}''${BAR4}''${BAR5}"

    echo "{\"text\": \" ''${BARS}\", \"tooltip\": \"Wi-Fi: ''${ESSID} (''${SIGNAL}%)\"}"
  '';
  executable = true;
};
  home.file.".config/waybar/cpu-spark.sh" = {
    executable = true;
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

      echo "{\"text\": \"CPU ''${usage}% ''${history}\", \"tooltip\": \"CPU: ''${usage}%\"}"
    '';
  };

  home.file.".config/waybar/memory.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      mem=$(free | awk '/Mem:/ {print int($3/$2 * 100)}')
      echo "{\"text\": \"MEM ''${mem}%\", \"tooltip\": \"Memory: ''${mem}%\"}"
    '';
  };

  # --- waybar itself ---
  programs.waybar = {
    enable = true;
    systemd.enable = true;


style = ''
  * {
    font-family: "Terminus", "Font Awesome 7 Free", monospace;
    font-size: 11px;
    min-height: 20px;
    border: none;
    border-radius: 0;
  }

  window#waybar {
    background: ${t.bg};
    border-bottom: 1px solid ${t.purple};
    color: ${t.fg};
  }

  #custom-launcher {
    color: ${t.pink};
    padding: 0 14px;
    font-size: 12px;
   
  }
  #custom-launcher:hover { color: ${t.teal}; }

  #wlr-taskbar { padding: 0 6px; }

  /* taskbar active window gets a pink underline */
  #wlr-taskbar button.active {
    border-bottom: 2px solid ${t.pink};
    color: ${t.fg};
  }
  #wlr-taskbar button {
    color: ${t.fgMuted};
    padding: 0 6px;
  }

  #clock {
    color: ${t.teal};
    padding: 0 12px;
   
  }

  /* semantic colour mapping:
     orange = heat (CPU)
     yellow = memory pressure
     green  = disk (storage = calm)
     teal   = network
     yellow = battery (warn when low)
     pink   = volume (audio = personality) */
  #custom-cpu    { color: ${t.orange};   padding: 0 8px; }
  #custom-memory { color: ${t.yellow};   padding: 0 8px; }
  #custom-disk   { color: ${t.green};    padding: 0 8px; }
  #custom-wifi   { color: ${t.teal};     padding: 0 8px; }
  #custom-battery{ color: ${t.yellow};   padding: 0 8px; }
  #custom-volume { color: ${t.pink};     padding: 0 8px; }

  #tray {
    padding: 0 8px;
   
  }

  tooltip {
    background: ${t.bgAlt};
    border: 1px solid ${t.purple};
    color: ${t.fg};
    border-radius: 4px;
  }
'';
    settings = [{
      layer = "top";
      position = "top";
      height = 32;
      exclusive = true;

      modules-left = [
        "custom/launcher"
        "wlr/taskbar"
      ];

      modules-center = [ "clock" ];

      modules-right = [
        "custom/cpu"
        "custom/memory"
        "custom/wifi"
        "custom/battery"
        "custom/volume"	
        "tray"
      ];

      "custom/launcher" = {
        format = "[ ! ]";
        on-click = "kitty --app-id fsel --detach -e fsel-menu";
        tooltip = false;
      };

      "wlr/taskbar" = {
        on-click = "activate";
        on-click-middle = "close";
        format = "{name}";
	sort-by-app-id = true;
        max-length = 20;
      };

      clock = {
        format = " {:%H:%M}";
        format-alt = " {:%d-%m-%Y %H:%M}";
        tooltip-format = "{:%A, %B %d %Y}";
      };

      "custom/cpu" = {
        exec = "~/.config/waybar/cpu-spark.sh";
        interval = 2;
        return-type = "json";
      };

      "custom/memory" = {
        exec = "~/.config/waybar/memory.sh";
        interval = 5;
        return-type = "json";
      };

      "custom/wifi" = {
        exec = "~/.config/waybar/wifi-bar.sh";
        interval = 10;
	on-click = "kitty --app-id nmtui --detach -e nmtui";
        return-type = "json";
      };

      "custom/battery" = {
        exec = "~/.config/waybar/battery-bar.sh";
        interval = 30;
        return-type = "json";
      };

      "custom/volume" = {
        exec = "~/.config/waybar/volume-bar.sh";
        interval = "once";
	signal = 8;
	on-click = "kitty --app-id wiremix --detach -e wiremix";
        return-type = "json";
      };

      tray = {
        icon-size = 14;
        spacing = 8;
      };
    }];
  };
}
