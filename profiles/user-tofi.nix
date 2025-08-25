{ pkgs, ... }:

{
  home.packages = with pkgs; [
    
    (pkgs.writeShellScriptBin "tofi-ascii" ''
      #!/usr/bin/env bash

      # top border
      echo "╔══════════════════════════════════╗"

      # run tofi in the middle
      tofi-drun \
        --prompt-text "║ >> " \
        --no-icons \
        --text-color "#ffffff" \
        --background-color "#000000ee" \
        --selection-background "#ffffff" \
        --selection-color "#000000" \
        --font "monospace 14" \
        --anchor center \
        --x 50% --y 50% \
        --width 600 --height 400 \
        --horizontal false

      # bottom border
      echo "╚══════════════════════════════════╝"
    '')
  ];

  # tofi config (optional, for cleaner style overrides)
  xdg.configFile."tofi/config".text = ''
    font = monospace 14
    anchor = center
    x = 50%
    y = 50%
    width = 600
    height = 400
    horizontal = false
    background-color = #000000ee
    text-color = #ffffff
    selection-background = #ffffff
    selection-color = #000000
  '';
}
