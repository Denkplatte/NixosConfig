# TUI login screen (greetd + tuigreet) with a figlet banner.
{ pkgs, lib, hostname, theme, ... }:

let
  figletFonts = import ../../../theme/figlet-fonts.nix { inherit pkgs; };

  # Rendered at build time into a plain text file.
  bannerFile = pkgs.runCommand "greetd-banner" {
    nativeBuildInputs = [ pkgs.figlet pkgs.boxes ];
    LANG   = "C.UTF-8";
    LC_ALL = "C.UTF-8";
  } ''
    figlet -d ${figletFonts} -f 'ANSI Shadow' '[ ! ]' | boxes -d ansi-double > $out
  '';
in
{
  # tuigreet shows /etc/issue above the login box (--issue).
  environment.etc."issue".text = ''
    ${builtins.readFile bannerFile}
    WELCOME TO ${lib.toUpper hostname}.

  '';

  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = lib.concatStringsSep " " [
        "${pkgs.tuigreet}/bin/tuigreet"
        "--remember"
        "--remember-session"
        "--time"
        "--issue"
        "--theme 'border=${theme.purple};text=${theme.fg};prompt=${theme.pink};time=${theme.teal};action=${theme.teal};button=${theme.pink};container=${theme.bg};input=${theme.yellow}'"
      ];
    };
  };
}
