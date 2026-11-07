# Waybar (started by driftwm autostart) + its custom module scripts.
# Scripts are built into the Nix store with their dependencies on PATH,
# so they work on any machine without relying on globally installed tools.
{ pkgs, lib, theme, ... }:

let
  mkScript = name: deps: text: pkgs.writeShellScript name ''
    export PATH=${lib.makeBinPath ([ pkgs.coreutils pkgs.gnugrep pkgs.gawk ] ++ deps)}:$PATH
    ${text}
  '';

  # Terminal popups opened from the bar.
  popup = appId: cmd: "kitty --app-id ${appId} --detach -e ${cmd}";

  battery = mkScript "waybar-battery" [ ] ''
    # First battery found; print nothing (module hidden) on machines without one.
    BAT=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
    [ -z "$BAT" ] && exit 0

    BATTERY=$(cat "$BAT/capacity" 2>/dev/null || echo 0)
    STATUS=$(cat "$BAT/status" 2>/dev/null || echo "Unknown")
    echo "$STATUS" | grep -q "Charging" && CHARGING="⚡" || CHARGING=""

    INTERIOR_WIDTH=10
    FILLED_WIDTH=$(( BATTERY * INTERIOR_WIDTH / 100 ))

    FILLED=""
    for ((i=0; i<FILLED_WIDTH; i++)); do FILLED="''${FILLED}█"; done

    EMPTY=""
    for ((i=FILLED_WIDTH; i<INTERIOR_WIDTH; i++)); do EMPTY="''${EMPTY}░"; done

    LINE1="   ╔══════════╗"
    LINE2="   ║''${FILLED}''${EMPTY}║║''${CHARGING}"
    LINE3="   ╚══════════╝"

    echo "{\"text\": \"''${LINE1}\n''${LINE2}\n''${LINE3}\", \"tooltip\": \"Battery: ''${BATTERY}% (''${STATUS})\"}"
  '';

  volume = mkScript "waybar-volume" [ pkgs.wireplumber ] ''
    RAW=$(LC_ALL=C wpctl get-volume @DEFAULT_AUDIO_SINK@)
    MUTED=$(echo "$RAW" | grep -q MUTED && echo "1" || echo "0")
    VOLUME=$(echo "$RAW" | awk '{printf "%d", $2 * 100}')

    [ "$VOLUME" -gt 100 ] && VOLUME=100

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

  # Watches PipeWire for sink (volume/mute) events and tells waybar to refresh
  # the volume module (signal 8).
  volumeWatcher = mkScript "waybar-volume-watcher" [ pkgs.pulseaudio pkgs.procps ] ''
    pactl subscribe 2>/dev/null | grep --line-buffered "sink" | while read -r _; do
      pkill -SIGRTMIN+8 waybar
    done
  '';

  wifi = mkScript "waybar-wifi" [ pkgs.networkmanager ] ''
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

    BARS=" ''${BAR1}''${BAR2}''${BAR3}''${BAR4}''${BAR5}"

    echo "{\"text\": \" ''${BARS}\", \"tooltip\": \"Wi-Fi: ''${ESSID} (''${SIGNAL}%)\"}"
  '';

  vpn = mkScript "waybar-vpn" [ pkgs.networkmanager pkgs.iproute2 ] ''
    # Prefer NetworkManager's view (gives a friendly connection name).
    VPN_NAME=$(nmcli -t -f TYPE,NAME connection show --active 2>/dev/null \
      | awk -F: '$1 == "vpn" || $1 == "wireguard" { print $2; exit }')

    # Fallback: a tunnel interface that's up, even if NM doesn't know about it.
    if [ -z "$VPN_NAME" ]; then
      IFACE=$(ip -o link show up 2>/dev/null \
        | awk -F': ' '{print $2}' \
        | grep -E '^(tun|wg|ppp)[0-9]*' | head -1)
      [ -n "$IFACE" ] && VPN_NAME="$IFACE"
    fi

    if [ -n "$VPN_NAME" ]; then
      echo "{\"text\": \"\", \"tooltip\": \"VPN: ''${VPN_NAME}\", \"class\": \"connected\"}"
    else
      echo "{\"text\": \"\", \"tooltip\": \"VPN: disconnected\", \"class\": \"disconnected\"}"
    fi
  '';

  cpu = mkScript "waybar-cpu" [ ] ''
    FILE="''${XDG_RUNTIME_DIR:-/tmp}/waybar-cpu-spark"
    MAXLEN=10

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    total=$((user+nice+system+idle+iowait+irq+softirq+steal))
    idle_all=$((idle+iowait))

    usage=0
    if [ -f "$FILE.prev" ]; then
      read -r prev_total prev_idle < "$FILE.prev"
      diff_total=$((total - prev_total))
      diff_idle=$((idle_all - prev_idle))
      [ "$diff_total" -gt 0 ] && usage=$(( (100*(diff_total-diff_idle)) / diff_total ))
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

  memory = mkScript "waybar-memory" [ pkgs.procps ] ''
    mem=$(free | awk '/Mem:/ {print int($3/$2 * 100)}')
    echo "{\"text\": \"MEM ''${mem}%\", \"tooltip\": \"Memory: ''${mem}%\"}"
  '';
in
{
  # Started by driftwm autostart (see driftwm.nix) and by graphical-session.target.
  systemd.user.services.waybar-volume-watcher = {
    Unit = {
      Description = "PipeWire volume event watcher for Waybar";
      After = [ "pipewire.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${volumeWatcher}";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # --- waybar itself ---
  programs.waybar = {
    enable = true;
    systemd.enable = false;


style = ''
  * {
    font-family: "Terminus", "Font Awesome 7 Free", monospace;
    font-size: 11px;
    min-height: 20px;
    border: none;
    border-radius: 0;
  }

  window#waybar {
    background: ${theme.bg};
    border-bottom: 1px solid ${theme.purple};
    color: ${theme.fg};
  }

  #custom-launcher {
    color: ${theme.pink};
    padding: 0 14px;
    font-size: 12px;
   
  }
  #custom-launcher:hover { color: ${theme.teal}; }

  #wlr-taskbar { padding: 0 6px; }

  /* taskbar active window gets a pink underline */
  #wlr-taskbar button.active {
    border-bottom: 2px solid ${theme.pink};
    color: ${theme.fg};
  }
  #wlr-taskbar button {
    color: ${theme.fgMuted};
    padding: 0 6px;
  }

  #clock {
    color: ${theme.teal};
    padding: 0 12px;
   
  }

  /* semantic colour mapping:
     orange = heat (CPU)
     yellow = memory pressure
     green  = disk (storage = calm)
     teal   = network
     yellow = battery (warn when low)
     pink   = volume (audio = personality) */
  #custom-cpu    { color: ${theme.orange};   padding: 0 8px; }
  #custom-memory { color: ${theme.yellow};   padding: 0 8px; }
  #custom-disk   { color: ${theme.green};    padding: 0 8px; }
  #custom-wifi   { color: ${theme.teal};     padding: 0 8px; }
  #custom-battery{ color: ${theme.yellow};   padding: 0 8px; }
  #custom-volume { color: ${theme.pink};     padding: 0 8px; }
  #custom-vpn.connected    { color: ${theme.green}; }
  #custom-vpn.disconnected { color: ${theme.fgMuted}; }


  #tray {
    padding: 0 8px;
   
  }

  tooltip {
    background: ${theme.bgAlt};
    border: 1px solid ${theme.purple};
    color: ${theme.fg};
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
        "custom/vpn"
        "custom/battery"
        "custom/volume"        
        "tray"
      ];

      "custom/launcher" = {
        format = "[ ! ]";
        on-click = "exec fzf-launcher-toggle";
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
        exec = "${cpu}";
        interval = 2;
        return-type = "json";
      };

      "custom/memory" = {
        exec = "${memory}";
        interval = 5;
        return-type = "json";
      };

      "custom/wifi" = {
        exec = "${wifi}";
        interval = 10;
        on-click = popup "nmtui" "nmtui";
        return-type = "json";
      };
 
      "custom/vpn" = {
        exec = "${vpn}";
        interval = 5;
        on-click = popup "nmtui" "nmtui";
        return-type = "json";
      };

      "custom/battery" = {
        exec = "${battery}";
        interval = 30;
        return-type = "json";
      };

      "custom/volume" = {
        exec = "${volume}";
        interval = "once";
        signal = 8;
        on-click = popup "wiremix" "wiremix";
        return-type = "json";
      };

      tray = {
        icon-size = 14;
        spacing = 8;
      };
    }];
  };
}
