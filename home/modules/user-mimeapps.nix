{ pkgs, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain"         = [ "terminal-editor.desktop" ];
      "application/toml"   = [ "terminal-editor.desktop" ];
      "text/x-shellscript" = [ "terminal-editor.desktop" ];
      "application/json"   = [ "terminal-editor.desktop" ];
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "terminal-editor" ''
      exec kitty -e $EDITOR "$@"
    '')
  ];

  xdg.desktopEntries.terminal-editor = {
    name = "Terminal Editor";
    exec = "terminal-editor %F";
    terminal = false;
    type = "Application";
    mimeType = [
      "text/plain"
      "application/toml"
      "text/x-shellscript"
      "application/json"
    ];
  };
}
