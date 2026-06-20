{ pkgs, ... }:

{
  # fzf, figlet, and desktop-file-utils are already provided system-wide via
  # modules/system/packages.nix — only libnotify (for notify-send) is new here.
  home.packages = [
    pkgs.libnotify

    (pkgs.writeShellScriptBin "fzf-launcher" ''
      #!/usr/bin/env bash

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

            # Skip hidden applications
            if grep -q "^NoDisplay=true" "$desktop_file" 2>/dev/null; then
              continue
            fi

            # Extract name
            name=$(grep "^Name=" "$desktop_file" | head -n1 | cut -d= -f2-)
            if [ -n "$name" ]; then
              # Store mapping from name to file path
              app_to_file["$name"]="$desktop_file"
              echo "$name" >> "$temp_apps"
            fi
          done
        fi
      done

      # Remove duplicates and sort
      apps=$(sort -u "$temp_apps")
      rm -f "$temp_apps"

      # Show fzf menu with figlet header
      choice=$(printf "%s\n" "$apps" | \
        fzf --ansi \
            --header="$(figlet -d ~/.local/share/figlet/fonts -f 'DOS Rebel' '[!] Apps' 2>/dev/null || figlet '[!] Apps' 2>/dev/null || echo '[!] Apps')" \
            --prompt=">> " \
            --layout=reverse-list)

      # Exit if nothing was chosen
      [ -z "$choice" ] && exit 0

      # Get the desktop file for the chosen app
      desktop_file="''${app_to_file[$choice]}"

      if [ -z "$desktop_file" ] || [ ! -f "$desktop_file" ]; then
        notify-send "App Launcher" "Desktop file not found for: $choice" -t 3000
        exit 1
      fi

      # Extract Exec line
      exec_cmd=$(grep "^Exec=" "$desktop_file" | head -n1 | cut -d= -f2-)

      if [ -z "$exec_cmd" ]; then
        notify-send "App Launcher" "No Exec command found for: $choice" -t 3000
        exit 1
      fi

      # Clean up desktop file placeholders
      clean_cmd=$(echo "$exec_cmd" | sed -E 's/ *%[fFuUdDnNickvm]+//g' | sed 's/^ *//' | sed 's/ *$//')

      # Check if we should run in terminal
      terminal=$(grep "^Terminal=" "$desktop_file" | cut -d= -f2- 2>/dev/null || echo "false")

      # Launch with proper process detachment for window manager shortcuts
      if [ "$terminal" = "true" ]; then
        setsid kitty -e bash -c "$clean_cmd; read -p 'Press Enter to close...'" >/dev/null 2>&1 &
      else
        setsid bash -c "$clean_cmd" >/dev/null 2>&1 &
      fi

      # Give the process a moment to start properly
      sleep 0.2
    '')
  ];
}
