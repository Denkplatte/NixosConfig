{ pkgs, ... }:
let
  t = import ../../theme/hotline-miami.nix;
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "power-menu" ''
      banner=$(
        {
          printf '\033[38;2;0;229;204m'
          ${pkgs.figlet}/bin/figlet -f standard "POWER" -c
          printf '\033[0m'
        } | ${pkgs.boxes}/bin/boxes -d ansi-double
      )

      banner=$(printf '\033[38;2;255;45;120m%s\033[0m' "$banner")
      banner_lines=$(printf '%s\n' "$banner" | wc -l)

      {
        printf '%s\n' "$banner"
        printf '\n'
        printf '\033[38;2;255;107;26m  ⏻  Shutdown\033[0m\n'
        printf '\033[38;2;255;107;26m  ↺  Reboot\033[0m\n'
        printf '\033[38;2;0;229;204m  ⏾  Suspend\033[0m\n'
        printf '\033[38;2;122;110;138m  ⇥  Logout\033[0m\n'
      } | ${pkgs.fzf}/bin/fzf \
            --ansi \
            --no-info \
            --no-border \
            --prompt="  " \
            --pointer="▌" \
            --height=100% \
            --layout=reverse \
            --color="bg:#1a0a2e,bg+:#120720,fg:#e8e0d5,fg+:#00e5cc,pointer:#ff2d78,hl:#00e5cc,hl+:#00e5cc" \
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
  ];

  xdg.desktopEntries.power-menu = {
    name = "Power Menu";
    exec = "kitty --class power-menu -e power-menu";
    terminal = false;
    type = "Application";
    icon = "system-shutdown";
    categories = [ "System" ];
  };
}
