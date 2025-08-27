{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    figlet
    desktop-file-utils
    libnotify

    (pkgs.writeShellScriptBin "fzf-launcher" ''
      #!/usr/bin/env bash

      # Enable debugging
      DEBUG=1

      debug_log() {
        if [ "$DEBUG" = "1" ]; then
          echo "[DEBUG] $*" >&2
          notify-send "Debug" "$*" -t 2000
        fi
      }

      # Define search paths for desktop files
      search_paths=(
        "/run/current-system/sw/share/applications"
        "$HOME/.local/share/applications"
        "/usr/share/applications"
        "/usr/local/share/applications"
        "/var/lib/flatpak/exports/share/applications"
        "$HOME/.local/share/flatpak/exports/share/applications"
      )

      debug_log "Starting app launcher"

      # Collect all available apps from .desktop files
      declare -A app_to_file
      temp_apps=$(mktemp)

      for path in "''${search_paths[@]}"; do
        if [ -d "$path" ]; then
          debug_log "Searching in: $path"
          for desktop_file in "$path"/*.desktop; do
            [ -f "$desktop_file" ] || continue
            
            # Skip hidden applications
            if grep -q "^NoDisplay=true" "$desktop_file" 2>/dev/null; then
              continue
            fi
            
            # Extract name
            name=$(grep "^Name=" "$desktop_file" | head -n1 | cut -d= -f2-)
            if [ -n "$name" ]; then
              app_to_file["$name"]="$desktop_file"
              echo "$name" >> "$temp_apps"
            fi
          done
        fi
      done

      # Remove duplicates and sort
      apps=$(sort -u "$temp_apps")
      rm -f "$temp_apps"

      debug_log "Found $(echo "$apps" | wc -l) applications"

      # Show fzf menu with figlet header
      choice=$(printf "%s\n" "$apps" | \
        fzf --ansi \
            --header="$(figlet -f small '[!] Apps' 2>/dev/null || echo '[!] Apps')" \
            --prompt=">> " \
            --layout=reverse-list)

      # Exit if nothing was chosen
      [ -z "$choice" ] && exit 0

      debug_log "Selected: $choice"

      # Get the desktop file for the chosen app
      desktop_file="''${app_to_file[$choice]}"

      debug_log "Desktop file: $desktop_file"

      if [ -z "$desktop_file" ] || [ ! -f "$desktop_file" ]; then
        notify-send "App Launcher" "Desktop file not found for: $choice" -t 3000
        exit 1
      fi

      # Extract Exec line
      exec_cmd=$(grep "^Exec=" "$desktop_file" | head -n1 | cut -d= -f2-)
      debug_log "Raw exec command: $exec_cmd"

      if [ -z "$exec_cmd" ]; then
        notify-send "App Launcher" "No Exec command found for: $choice" -t 3000
        exit 1
      fi

      # Clean up desktop file placeholders
      clean_cmd=$(echo "$exec_cmd" | sed -E 's/ *%[fFuUdDnNickvm]+//g' | sed 's/^ *//' | sed 's/ *$//')
      debug_log "Cleaned command: $clean_cmd"

      # Check if we should run in terminal
      terminal=$(grep "^Terminal=" "$desktop_file" | cut -d= -f2- || echo "false")
      debug_log "Terminal mode: $terminal"

      # Try the simplest approach first
      debug_log "Attempting to launch..."
      
      if [ "$terminal" = "true" ]; then
        debug_log "Launching in terminal"
        xterm -e "$clean_cmd" &
      else
        debug_log "Launching normally"
        # Try multiple methods
        if command -v "$clean_cmd" >/dev/null 2>&1; then
          debug_log "Command found in PATH, executing directly"
          $clean_cmd &
        else
          debug_log "Using bash -c to execute"
          bash -c "$clean_cmd" &
        fi
      fi

      sleep 1
      debug_log "Launch attempted"
    '')

    # Also create a simple test version
    (pkgs.writeShellScriptBin "fzf-launcher-simple" ''
      #!/usr/bin/env bash
      
      # Simple version using desktop-file-utils
      choice=$(find /run/current-system/sw/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | \
        xargs -I {} basename {} .desktop | \
        sort -u | \
        fzf --prompt="App: ")
      
      [ -z "$choice" ] && exit 0
      
      # Use gtk-launch (from desktop-file-utils) which properly handles .desktop files
      gtk-launch "$choice" 2>/dev/null || notify-send "Failed to launch" "$choice"
    '')
  ];
}
