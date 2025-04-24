{ config, pkgs, ... }:

{
  boot.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false; # Set to true for Turing+ open kernel module
    nvidiaSettings = true;
  };

  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GL_VRR_ALLOWED = "1";
  };
}
