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
      cmd = "kitty --app-id btop --detach -e btop";
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
