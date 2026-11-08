# Extra launcher entries (shown by the fzf launcher).
{ ... }:

{
  xdg.desktopEntries.btop = {
    name = "btop++";
    exec = "kitty --app-id btop -e btop";
    terminal = false;
    type = "Application";
    categories = [ "System" ];
  };
}
