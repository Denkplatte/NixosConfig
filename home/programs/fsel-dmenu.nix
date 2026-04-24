{ pkgs, ... }:

let
  # 🔧 Define your menu entries here
  menuEntries = [
    {
      name = "Power Menu";
      cmd = "power-menu-launcher";
    }
    {
      name = "Firefox";
      cmd = "firefox";
    }
    {
      name = "Terminal";
      cmd = "kitty";
    }
    {
      name = "Unreal Engine";
      cmd = "launch-unreal";
    }
    {
      name = "btop";
      cmd = "kitty -o 'initial_window_width=200c' -o 'initial_window_height=100c' --app-id btop --detach -e btop ";
    }
    {
      name = "Superfile";
      cmd = "kitty --app-id superfile --detach -e superfile";
    }
  ];

  # 📋 Generate the menu list (what fsel shows)
  menuList =
    builtins.concatStringsSep "\n"
      (map (entry: entry.name) menuEntries);

  # ⚙️ Generate the case statement
  caseBlock =
    builtins.concatStringsSep "\n"
      (map (entry: ''
        "${entry.name}") ${entry.cmd} ;;
      '') menuEntries);

in
{
  home.file.".local/bin/fsel-menu" = {
    executable = true;
    text = ''
      #!/bin/sh

      choice=$(printf "${menuList}\n" | fsel --dmenu)

      case "$choice" in
      ${caseBlock}
      esac
    '';
  };
}
