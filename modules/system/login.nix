{ pkgs, ... }:

let
  t = import ../../theme/hotline-miami.nix;
  xeroFonts = import ../../theme/figletfonts.nix { inherit pkgs; };
  # Build the banner at Nix build time — outputs a plain text file
  bannerFile = pkgs.runCommand "greetd-banner" {
    nativeBuildInputs = [ pkgs.figlet pkgs.boxes ];
    LANG    = "C.UTF-8";
    LC_ALL  = "C.UTF-8";

  } ''
    figlet -d ${xeroFonts} -f 'ANSI Shadow' '[ ! ]' \
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
 	 ${pkgs.tuigreet}/bin/tuigreet \
    	--remember \
    	--remember-session \
    	--time \
    	--issue \
    	--theme "border=${t.purple};text=${t.fg};prompt=${t.pink};time=${t.teal};action=${t.teal};button=${t.pink};container=${t.bg};input=${t.yellow}"
	'';
        user = "greeter";
      };
    };
  };
}
