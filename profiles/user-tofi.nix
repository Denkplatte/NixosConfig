{ pkgs, ... }:

{
  home.packages = with pkgs; [
        
  pkgs.jq
    (pkgs.writeShellScriptBin "tofi-ascii" ''
      #!/usr/bin/env bash

      # Generate ASCII banner
      BANNER="$(figlet -f cricket "Launch")"

      # Build menu entries:
      #  - figlet banner (will not be executed)
      #  - separator line
      #  - list of commands from $PATH
      MENU="$(
        {
          echo "$BANNER"
          echo "──────────────────────────────"
          compgen -c | sort -u
        }
      )"

      # Run tofi
      CHOICE="$(echo "$MENU" | tofi "$@")"

      # Ignore banner/separator
      if [[ -z "$CHOICE" ]]; then
        exit 0
      fi
      if echo "$CHOICE" | grep -q "─"; then
        exit 0
      fi
      if echo "$BANNER" | grep -Fqx "$CHOICE"; then
        exit 0
      fi

      # Launch the chosen program
      exec swaymsg exec -- "$CHOICE"
    '')
  ];

  # tofi config (optional, for cleaner style overrides)
  xdg.configFile."tofi/config".text = ''
    font = terminus 14
    anchor = center
    width = 600
    height = 400
    horizontal = false
    background-color = #000000ee
    text-color = #ffffff
    selection-background = #ffffff
    selection-color = #000000
  '';
}
