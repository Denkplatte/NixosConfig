{ pkgs, gazellePackage, ... }:
{
  programs.gazelle = {
    enable = true;
    settings = {
      theme = "textual-dark";
    };
  };

  home.packages = [ gazellePackage ];
}
