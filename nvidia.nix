{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  # NVIDIA configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false; # Try with this disabled first
      
    };

    prime = {
      offload.enable = true; # Use NVIDIA as primary GPU
      # If you have Intel+NVIDIA hybrid graphics:
      intelBusId = "PCI:0:2:0"; # You may need to adjust this based on your system
      nvidiaBusId = "PCI:4:0:0"; # You may need to adjust this based on your system
    };
    # Use the latest driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    open = false;
    nvidiaSettings = true;
  };

  # Add necessary environment variables for Wayland + NVIDIA
  environment.variables = {
    # NVIDIA + Wayland variables
  #  "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
   # "GBM_BACKEND" = "nvidia-drm";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    
    # Graphics renderer settings
    #"WLR_RENDERER" = "gles2";
   # "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
    
    # Point to both GPUs
   # "WLR_DRM_DEVICES" = "/dev/dri/card0:/dev/dri/card1";
    
    # Fix common issues
   # "LIBGL_DRI3_DISABLE" = "1";
  };
}
