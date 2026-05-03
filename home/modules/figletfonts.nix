{pkgs, ... }:
{

# Put extra figlet fonts in your home config
  home.file.".local/share/figlet/fonts".source = pkgs.fetchFromGitHub {
  owner = "xero";
  repo = "figlet-fonts";
  rev = "master";
  sha256 = "sha256-/Qj8CWqn7w1R83enixxgC5ijUrHvqN3C7ZvRCs/AzBI=";
  };

}
