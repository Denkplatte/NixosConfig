{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      exec-once = "foot"; # or any terminal you like
      env = [
        "WLR_NO_HARDWARE_CURSORS,1"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "__GL_VRR_ALLOWED,1"
        "LIBVA_DRIVER_NAME,nvidia"
      ];
    };
  };
}
