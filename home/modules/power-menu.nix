{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "power-menu" ''
      choice=$(printf 'Shutdown\nReboot\nSuspend\nLogout' \
        | fzf \
            --prompt='  ' \
            --pointer='▌' \
            --info=hidden \
            --border=none \
            --height=6 \
            --color='bg+:-1,pointer:1,hl:1,fg+:2')

      case "$choice" in
        Shutdown) systemctl poweroff ;;
        Reboot)   systemctl reboot ;;
        Suspend)  systemctl suspend ;;
        Logout)   loginctl terminate-user "$USER" ;;
      esac
    '')
  ];

  xdg.desktopEntries.power-menu = {
    name = "Power Menu";
    exec = "kitty --title power-menu -e power-menu";
    terminal = false;
    type = "Application";
    icon = "system-shutdown";
    categories = [ "System" ];
  };
}
