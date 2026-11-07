# Active theme: palette + small helpers. Passed to every module as `theme`.
{ lib }:

let
  palette = import ./hotline-miami.nix;

  hexDigit = d: {
    "0" = 0;  "1" = 1;  "2" = 2;  "3" = 3;
    "4" = 4;  "5" = 5;  "6" = 6;  "7" = 7;
    "8" = 8;  "9" = 9;  "a" = 10; "b" = 11;
    "c" = 12; "d" = 13; "e" = 14; "f" = 15;
  }.${d};

  hexByte = s: (hexDigit (builtins.substring 0 1 s)) * 16
             + (hexDigit (builtins.substring 1 1 s));
in
palette // {
  # "#ff5a1f" -> "255;90;31", ready for \033[38;2;<rgb>m
  rgb = hex:
    let h = lib.toLower (lib.removePrefix "#" hex);
    in lib.concatMapStringsSep ";"
         (i: toString (hexByte (builtins.substring i 2 h))) [ 0 2 4 ];
}
