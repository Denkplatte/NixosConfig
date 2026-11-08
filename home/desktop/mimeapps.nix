# Open text-ish files in $EDITOR inside kitty.
{ pkgs, ... }:

let
  textTypes = [
    "text/plain"
    "application/toml"
    "text/x-shellscript"
    "application/json"
  ];
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "terminal-editor" ''
      exec kitty -e "''${EDITOR:-nano}" "$@"
    '')
  ];

  xdg.desktopEntries.terminal-editor = {
    name = "Terminal Editor";
    exec = "terminal-editor %F";
    terminal = false;
    type = "Application";
    mimeType = textTypes;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      builtins.listToAttrs (map (t: { name = t; value = [ "terminal-editor.desktop" ]; }) textTypes);
  };
}
