{ pkgs, ... }:

let
  t = import ../../theme/hotline-miami.nix;

  menuEntries = [
    { name = "Power Menu";    cmd = "power-menu-launcher"; }
    { name = "Firefox";       cmd = "firefox"; }
    { name = "Terminal";      cmd = "kitty"; }
    { name = "Unreal Engine"; cmd = "launch-unreal"; }
    { name = "btop";          cmd = "kitty -o 'initial_window_width=200c' -o 'initial_window_height=100c' --app-id btop --detach -e btop"; }
    { name = "Superfile";     cmd = "kitty --app-id superfile --detach -e superfile"; }
  ];

  menuList = builtins.concatStringsSep "\n" (map (e: e.name) menuEntries);

  caseBlock = builtins.concatStringsSep "\n"
    (map (e: ''        "${e.name}") setsid ${e.cmd} & ;;'') menuEntries);

in
{
  # Put the script in ~/.local/bin AND wrap it as a proper package
  # so it lands in $PATH via home.packages
  home.packages = [
    (pkgs.writeShellScriptBin "fsel-menu" ''
      export FZF_DEFAULT_OPTS="--color=bg:${t.bg},bg+:${t.bgAlt},fg:${t.fg},fg+:${t.teal},prompt:${t.pink},pointer:${t.pink},hl:${t.purple},hl+:${t.teal} --layout=reverse --prompt='>> ' --no-info"

      choice=$(printf '%s\n' "${menuList}" | fsel --dmenu)

      [ -z "$choice" ] && exit 0

      case "$choice" in
      ${caseBlock}
      esac
    '')
  ];
}
