{ pkgs, ...}:

{

 # Enable the SDDM display manager
  services.displayManager.sddm.enable = true;

  services.displayManager.sddm.wayland.enable = true;

# Enable the KDE Plasma desktop
  services.desktopManager.plasma6.enable = true;
}
