{ pkgs, ... }:

let
  xeroFonts = pkgs.fetchFromGitHub {
    owner = "xero";
    repo = "figlet-fonts";
    rev = "master";
    sha256 = "sha256-/Qj8CWqn7w1R83enixxgC5ijUrHvqN3C7ZvRCs/AzBI=";
  };

  banner = pkgs.runCommand "greetd-banner" {
    nativeBuildInputs = [ pkgs.figlet pkgs.boxes ];
  } ''
    figlet -d ${xeroFonts} -f "ANSI Shadow" "[ ! ]" | \
      ${pkgs.boxes}/bin/boxes -d ansi-double > $out
  '';

  welcomeScript = pkgs.writeShellScript "tuigreet-wrapper" ''
    clear
    printf '\033[35m'
    cat ${banner}
    printf '\033[36m'
    echo ""
    echo "   you know what you did."
    echo ""
    printf '\033[0m'
    exec ${pkgs.greetd.tuigreet}/bin/tuigreet \
      --remember \
      --remember-session \
      --time \
      --theme "border=magenta;text=white;prompt=magenta;time=cyan;action=cyan;button=magenta;container=black;input=yellow"
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${welcomeScript}";
        user = "greeter";
      };
    };
  };
}
