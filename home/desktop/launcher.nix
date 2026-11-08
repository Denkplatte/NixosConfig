# fzf-based app launcher + power menu (opened with the super key / waybar [ ! ]).
{ pkgs, lib, theme, ... }:

let
  t = theme;
  inherit (theme) rgb;

  figletFonts = import ../../theme/figlet-fonts.nix { inherit pkgs; };

  # Everything the launcher calls, so it doesn't depend on globally installed tools.
  launcherPath = lib.makeBinPath (with pkgs; [
    coreutils gnugrep gnused gawk findutils ncurses figlet fzf dex libnotify util-linux
  ]);

  # ── power options, shown at the bottom of the launcher ────────────────────
  powerEntries = [
    { icon = "⏻"; label = "Shut Down"; color = t.orange;  cmd = "systemctl poweroff"; }
    { icon = "↺"; label = "Restart";   color = t.pink;    cmd = "systemctl reboot"; }
    { icon = "󰒲"; label = "Suspend";   color = t.teal;    cmd = "systemctl suspend"; }
    { icon = "󰗽"; label = "Log Out";   color = t.fgMuted; cmd = "loginctl terminate-user \"$USER\""; }
  ];

  dividerLabel = lib.concatStrings (lib.replicate 20 "─");

  powerLine   = e: "printf '\\033[38;2;${rgb e.color}m${e.icon}  ${e.label}\\033[0m\\n'";
  dividerLine = "printf '\\033[38;2;${rgb t.fgMuted}m${dividerLabel}\\033[0m\\n'";

  powerBlockScript = lib.concatStringsSep "\n" ([ dividerLine ] ++ map powerLine powerEntries);

  powerCaseBlock = ''
    "${dividerLabel}") exit 0 ;;
  '' + lib.concatStringsSep "\n" (map (e: ''
    "${e.icon}  ${e.label}") ${e.cmd}; exit 0 ;;
  '') powerEntries);

in
{
  home.packages = [
    (pkgs.writeShellScriptBin "fzf-launcher-toggle" ''
    PIDFILE="''${XDG_RUNTIME_DIR:-/tmp}/fzf-launcher.pid"

    if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
     exit 0
    fi

    echo $$ > "$PIDFILE"
    trap 'rm -f "$PIDFILE"' EXIT

    kitty --app-id app-launcher --title app-launcher fzf-launcher
    '')


    (pkgs.writeShellScriptBin "fzf-launcher" ''
      # Appended so apps started from here still see the normal system PATH first.
      export PATH=$PATH:${launcherPath}

      cols=$(tput cols)
      rows=$(tput lines)

      # ── left panel: a single static "[!]" banner, shown via fzf's preview window ──
      preview_pct=35
      preview_width=$(( cols * preview_pct / 100 - 4 ))  
      (( preview_width < 10 )) && preview_width=10

      raw_banner=$(figlet -d ${figletFonts} -f 'ANSI Shadow' '[!]' 2>/dev/null \
        || figlet '[!]' 2>/dev/null)

      banner_width=$(printf '%s\n' "$raw_banner" | awk '{ print length }' | sort -rn | head -1)
      banner_height=$(printf '%s\n' "$raw_banner" | wc -l)

      h_pad=$(( (preview_width - banner_width) / 2 ))
      (( h_pad < 0 )) && h_pad=0
      v_pad=$(( (rows - banner_height) / 2 ))
      (( v_pad < 0 )) && v_pad=0

      banner_file=$(mktemp)
      trap 'rm -f "$banner_file"' EXIT
      {
        for _ in $(seq "$v_pad"); do echo; done
        printf '%s\n' "$raw_banner" | sed "s/^/$(printf '%*s' "$h_pad" "")/"
      } > "$banner_file"

      # Define search paths for desktop files
      search_paths=(
        "/run/current-system/sw/share/applications"
        "$HOME/.local/share/applications"
        "/usr/share/applications"
        "/usr/local/share/applications"
        "/var/lib/flatpak/exports/share/applications"
        "$HOME/.local/share/flatpak/exports/share/applications"
      )

      # Collect all available apps from .desktop files
      declare -A app_to_file
      temp_apps=$(mktemp)

      for path in "''${search_paths[@]}"; do
        if [ -d "$path" ]; then
          for desktop_file in "$path"/*.desktop; do
            [ -f "$desktop_file" ] || continue

            if grep -q "^NoDisplay=true" "$desktop_file" 2>/dev/null; then
              continue
            fi

            name=$(grep "^Name=" "$desktop_file" | head -n1 | cut -d= -f2-)
            if [ -n "$name" ]; then
              app_to_file["$name"]="$desktop_file"
              echo "$name" >> "$temp_apps"
            fi
          done
        fi
      done

      apps=$(sort -u "$temp_apps")
      rm -f "$temp_apps"

      # ── power options: colored, icon-prefixed, separated by a divider ──────
      power_block=$(
        ${powerBlockScript}
      )

      menu=$(
        printf '%s\n' "$apps"
        printf '%s\n' "$power_block"
      )

      # ── the menu: two columns via --preview, both borders via fzf's own border system ──
      choice=$(
        printf '%s\n' "$menu" \
        | fzf --ansi \
              --border=double \
              --preview="cat '$banner_file'" \
              --preview-window="left,''${preview_pct}%,border-double" \
              --prompt=">> " \
              --layout=reverse \
              --no-info \
              --color="bg:${t.bg},bg+:${t.bgAlt},fg+:-1,pointer:${t.pink},hl:${t.purple},hl+:${t.teal}"
      )

      [ -z "$choice" ] && exit 0

      # Strip the ANSI codes we embedded in the power-menu lines so the
      # `case` below can match on plain text.
      choice_clean=$(printf '%s' "$choice" | sed -E 's/\x1b\[[0-9;]*m//g')

      case "$choice_clean" in
      ${powerCaseBlock}
      esac

      desktop_file="''${app_to_file[$choice_clean]}"

      if [ -z "$desktop_file" ] || [ ! -f "$desktop_file" ]; then
        notify-send "App Launcher" "Desktop file not found for: $choice_clean" -t 3000
        exit 1
      fi

      # dex launches the .desktop file properly (working dir, quoting, Terminal=true).
      export TERMINAL="kitty"
      setsid dex "$desktop_file" >/dev/null 2>&1 &

      sleep 0.2
    '')
  ];
}
