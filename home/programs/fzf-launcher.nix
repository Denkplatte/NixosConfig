{ pkgs, ... }:

{
  # fzf, figlet, boxes, and desktop-file-utils are already provided system-wide
  # via modules/system/packages.nix. We are adding libnotify and dex!
  home.packages = [
    pkgs.libnotify
    pkgs.dex

    (pkgs.writeShellScriptBin "fzf-launcher" ''
      #!/usr/bin/env bash

      cols=$(tput cols)
      rows=$(tput lines)

      # ── left panel: a single static "[!]" banner, shown via fzf's preview window ──
      preview_pct=35
      preview_width=$(( cols * preview_pct / 100 - 4 ))  
      (( preview_width < 10 )) && preview_width=10

      raw_banner=$(figlet -d ~/.local/share/figlet/fonts -f 'ANSI Shadow' '[!]' 2>/dev/null \
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

      # ── the menu: two columns via --preview, both borders via fzf's own border system ──
      choice=$(
        printf '%s\n' "$apps" \
        | fzf --ansi \
              --border=double \
              --preview="cat '$banner_file'" \
              --preview-window="left,''${preview_pct}%,border-double" \
              --prompt=">> " \
              --layout=reverse
      )

      [ -z "$choice" ] && exit 0

      desktop_file="''${app_to_file[$choice]}"

      if [ -z "$desktop_file" ] || [ ! -f "$desktop_file" ]; then
        notify-send "App Launcher" "Desktop file not found for: $choice" -t 3000
        exit 1
      fi

      # ── THE FIX ──
      # We tell dex what our preferred terminal is in case Terminal=true is set
      export TERMINAL="kitty"
      
      # We use dex to natively launch the desktop file. This respects working directories,
      # environment variables, nested quotes, and NixOS FHS wrappers natively!
      setsid dex "$desktop_file" >/dev/null 2>&1 &

      sleep 0.2
    '')
  ];
}
