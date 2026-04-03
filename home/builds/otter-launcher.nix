{ pkgs, ... }:

let
  otter-launcher = pkgs.rustPlatform.buildRustPackage {
    pname = "otter-launcher";
    version = "0.6.7";

    src = pkgs.fetchFromGitHub {
      owner = "kuokuo123";
      repo = "otter-launcher";
      rev = "v0.6.7";
      hash = "sha256-6dfPaVG5bDf2nJfWV/RZnUGQEs4d9ZiUms2iNX/Ua1M=";
    };

    cargoHash = "sha256-SnZdNDK9TjIN9nV6FWIUAZgh/veMTggGb4Mp0kYOZ1k=";
  };
in
{
  home.packages = [ otter-launcher ];

home.file.".config/otter-launcher/header.sh" = {
  executable = true;
  text = ''
    #!/bin/sh
    printf '\033[90m'
    cat << 'EOF'
    ░█▀█░▀█▀░▀█▀░█▀▀░█▀█░░░░░ ░ ░
    ░█░█░░█░░░█░░█▀▀░█▀▄░▀▀▀░ ░ ░
    ░▀▀▀░░▀░░░▀░░▀▀▀░▀░▀░░░░░ ░ ░
    ░█░░░█▀█░█░█░█▀█░█▀▀░█░█░ ░ ░
    ░█░░░█▀█░█░█░█░█░█░░░█▀█░ ░ ░
    ░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░ ░ ░
    EOF
  '';
};

home.file.".config/otter-launcher/config.toml".text = ''
  [interface]
  header = ""
  header_cmd = "${config.home.homeDirectory}/.config/otter-launcher/header.sh"
  placeholder = "search..."
  suggestion_lines = 8

  [[modules]]
  description = "launch app"
  prefix = ""
  cmd = "xdg-open $input &"

  [[modules]]
  description = "google search"
  prefix = "gg"
  cmd = "xdg-open 'https://google.com/search?q=$input' &"

  [[modules]]
  description = "firefox"
  prefix = "ff"
  cmd = "firefox &"
'';

}

