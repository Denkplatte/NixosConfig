{pkgs, ...}:

{
  services.xserver.displayManager.gdm.wayland = true;
  #Enable gnome
  services.xserver.desktopManager.gnome.enable = true;
}
