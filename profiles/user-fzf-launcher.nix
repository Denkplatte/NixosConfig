{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    figlet
  ];

  home.file."bin/fzf-launcher".text = ''
    #!/usr/bin/env bash
    apps=$(grep -h "^Name=" /run/current-system/sw/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null \
      | cut -d= -f2 | sort -u)

    choice=$(printf "%s\n" "$apps" | \
      fzf --ansi \
          --header="$(figlet -f slant 'Apps')" \
          --prompt=">> " \
          --layout=reverse)

    [ -z "$choice" ] && exit 0

    exec_cmd=$(grep -h -A5 -F "Name=$choice" /run/current-system/sw/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null \
      | grep "^Exec=" \
      | head -n1 \
      | cut -d= -f2 \
      | sed 's/ *%[fFuUdDnNickvm]//g')

    exec $exec_cmd &
  '';
}
