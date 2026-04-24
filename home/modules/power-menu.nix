{ pkgs, ... }:
let
  t = import ../../theme/hotline-miami.nix;
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "power-menu" ''
      cols=$(tput cols)
      item_width=25
      pad=$(printf '%*s' "$(( (cols - item_width) / 2 ))" "")

      banner=$(
        {
          printf '\033[38;2;255;42;138m'   # t.pink  = #ff2a8a
          ${pkgs.figlet}/bin/figlet -cf banner3-D "POWER"
          printf '\033[0m'
        } | ${pkgs.boxes}/bin/boxes -d ansi-double
      )

      # wrap banner in purple (t.purple = #7a00ff → 122;0;255)
      banner=$(printf '\033[38;2;122;0;255m%s\033[0m' "$banner")
      banner_lines=$(printf '%s\n' "$banner" | wc -l)

      {
        printf '%s\n' "$banner"
        printf '\n'
        # orange  t.orange  = #ff5a1f → 255;90;31
        printf "''${pad}\033[38;2;255;90;31m⏻  Shutdown\033[0m\n"
        # pink    t.pink    = #ff2a8a → 255;42;138
        printf "''${pad}\033[38;2;255;42;138m↺  Reboot\033[0m\n"
        # teal    t.teal    = #00ffd5 → 0;255;213
        printf "''${pad}\033[38;2;0;255;213m⏾  Suspend\033[0m\n"
        # fgMuted t.fgMuted = #6e5a8a → 110;90;138
        printf "''${pad}\033[38;2;110;90;138m⇥  Logout\033[0m\n"
      } | ${pkgs.fzf}/bin/fzf \
            --ansi \
            --no-info \
            --no-border \
            --no-separator \
            --prompt="" \
            --pointer=" " \
            --height=100% \
            --layout=reverse \
            --highlight-line \
            --color="bg:${t.bg},bg+:${t.bgAlt},fg:${t.fg},fg+:${t.teal},pointer:${t.pink},hl:${t.teal},hl+:${t.teal}" \
            --header-lines="$((banner_lines + 1))" \
      | {
          read -r choice
          choice=$(echo "$choice" | sed 's/^[[:space:]]*//' | awk '{print $NF}')
          case "$choice" in
            Shutdown) systemctl poweroff ;;
            Reboot)   systemctl reboot ;;
            Suspend)  systemctl suspend ;;
            Logout)   loginctl terminate-user "$USER" ;;
          esac
        }
    '')

    (pkgs.writeShellScriptBin "power-menu-launcher" ''
      #!/bin/sh
      exec kitty \
        --app-id "power-menu" \
        --name "power-menu" \
        --title "Power Menu" \
        -e power-menu
    '')
  ];

  xdg.desktopEntries.power-menu = {
    name = "Power Menu";
    exec = "power-menu-launcher";
    terminal = false;
    type = "Application";
    icon = "system-shutdown";
    categories = [ "System" ];
  };
}
