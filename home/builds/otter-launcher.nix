{config, pkgs, ... }:

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
    cat  <<  'EOF'| ${pkgs.boxes}/bin/boxes -d ansi-double
███╗    ██╗    ███╗    ██╗      █████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗███████╗██████╗ 
██╔╝    ██║    ╚██║    ██║     ██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗
██║     ██║     ██║    ██║     ███████║██║   ██║██╔██╗ ██║██║     ███████║█████╗  ██████╔╝
██║     ╚═╝     ██║    ██║     ██╔══██║██║   ██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██╗
███╗    ██╗    ███║    ███████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║
╚══╝    ╚═╝    ╚══╝    ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
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
  description = "google search"
  prefix = "gg"
  cmd = "xdg-open https://www.google.com/search?q='{}'"
  # if with_argument is true, {} in cmd will be replaced with user input. if not explicitly set, taken as false.
  with_argument = true
  # url_encode should be true when calling webpages; this ensures special characters in url being readable to browsers; taken as false if not explicitly set
  url_encode = true
  # run cmd in a forked shell as opposed to as a child process (simply by prepending setsid -f to the configured cmd); useful for launching gui programs; taken as false if not explicitly set
  unbind_proc = true
 
  # fsel is needed to run below functions 
  [[modules]]
  description = "desktop programs"
  prefix = "app"
  cmd = "fsel --detach -ss {}"
  with_argument = true
  
  [[modules]]
  description = "power menu (fzf)"
  prefix = "po"
  cmd = """
  function power {
  if [[ -n $1 ]]; then
  case $1 in
  "logout") session=`loginctl session-status | head -n 1 | awk '{print $1}'`; loginctl terminate-session $session ;;
  "suspend") systemctl suspend ;;
  "hibernate") systemctl hibernate ;;
  "reboot") systemctl reboot ;;
  "shutdown") systemctl poweroff ;;
  esac fi }
  power $(echo -e 'reboot\nshutdown\nlogout\nsuspend\nhibernate' | fzf --info-command 'printf " power menu ($FZF_POS/$FZF_TOTAL_COUNT)"' --cycle --gutter " " --pointer " ▌" --color "bg+:-1,pointer:1,info:8,separator:8,scrollbar:0" --prompt '  ' | tail -1)
  """

  [[modules]]
  description = "run commands"
  prefix = "sh"
  cmd = """
  $(printf $TERM | sed 's/xterm-//g') -e sh -c "{}"
  """
  with_argument = true
  unbind_proc = true


  [[modules]]
  description = "open files (fzf)"
  prefix = "fo"
  cmd = """
  find $HOME -type f -not -path '*/.cache/*' 2>/dev/null | fzf --info-command 'printf " files ($FZF_POS/$FZF_TOTAL_COUNT)"' --cycle --gutter ' ' --pointer ' ▌' --color 'bg+:-1,pointer:1,info:8,separator:8,scrollbar:0' --prompt '  ' | setsid -f xargs -r -I [] xdg-open '[]'
  """

  [[modules]]
  description = "open dirs (yazi)"
  prefix = "yz"
  cmd = """
  find $HOME -type d -not -path '*/.cache/*' 2>/dev/null | fzf --info-command 'printf " directories ($FZF_POS/$FZF_TOTAL_COUNT)"' --cycle --gutter ' ' --pointer ' ▌' --color 'bg+:-1,pointer:1,info:8,separator:8,scrollbar:0' --prompt '  ' | xargs -r -I [] setsid -f "$(echo $TERM | sed 's/xterm-//g')" -e yazi '[]'
  """
 '';

}

