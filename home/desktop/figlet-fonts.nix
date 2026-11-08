# Extra figlet fonts in ~/.local/share/figlet/fonts (use: figlet -d ~/.local/share/figlet/fonts -f '<font>').
{ pkgs, ... }:

{
  home.file.".local/share/figlet/fonts".source =
    import ../../theme/figlet-fonts.nix { inherit pkgs; };
}
