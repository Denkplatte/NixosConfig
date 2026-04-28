{ pkgs, ... }:
{
  programs.gazelle = {
    enable = true;
    settings = {
      theme = "textual-dark";
    };
  };
}
