{ pkgs, ... }:

let
  t = import ../../theme/hotline-miami.nix;

  xeroFonts = pkgs.fetchFromGitHub {
    owner = "xero";
    repo  = "figlet-fonts";
    rev   = "master";
    sha256 = "sha256-/Qj8CWqn7w1R83enixxgC5ijUrHvqN3C7ZvRCs/AzBI=";
  };

  # Build the banner at Nix build time — outputs a plain text file
  bannerFile = pkgs.runCommand "greetd-banner" {
    nativeBuildInputs = [ pkgs.figlet pkgs.boxes ];
  } ''
    figlet -f cricket "[ ! ]" \
      | ${pkgs.boxes}/bin/boxes -d ansi-double \
      > $out
  '';

  # Read the banner at eval time so we can embed it in /etc/issue
  bannerText = builtins.readFile bannerFile;
in
{
  # Write banner + welcome text into /etc/issue
  # tuigreet renders this natively via --issue above the login box
  environment.etc."issue".text = ''
    ${bannerText}
    WELCOME TO DENKPLATTE.

  '';

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --remember \
            --remember-session \
            --time \
            --issue \
            --theme "border=magenta;text=white;prompt=magenta;time=cyan;action=cyan;button=magenta;container=black;input=yellow"
        '';
        user = "greeter";
      };
    };
  };
}
