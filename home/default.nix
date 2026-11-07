# Shared Home Manager config for the main user (see lib/mkHost.nix).
{ username, ... }:

{
  imports = [
    ./desktop
    ./programs
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };
}
