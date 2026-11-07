# Shared system modules, imported by every host (see lib/mkHost.nix).
{
  imports = [
    ./core
    ./desktop
    ./hardware
    ./services
  ];
}
