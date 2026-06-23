{ pkgs, ... }:
let
  figletFontsSrc = import ../../theme/figletfonts.nix { inherit pkgs; };
in
{
  home.file.".local/share/figlet/fonts".source = figletFontsSrc;
}
