{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

  extraPackages = with pkgs; [
   nvidia-vaapi-driver
   libvdpau-va-gl
  ];

  };

  services.xserver.videoDrivers = ["nvidia"];

  # NVIDIA configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false; # Try with this disabled first
      
    };

    prime = {
      sync.enable = true; # Use NVIDIA as primary GPU
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
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "WLR_NO_HARDWARE_CURSORS" = "1";
   # "LIBVA_DRIVER_NAME" = "nvidia";
    # Graphics renderer settings
   # "WLR_RENDERER" = "vulkan";
   # "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
    "LIBVA_DRIVER_NAME" = "nvidia";  # or "iHD" for newer Intel GPUs
    # Point to both GPUs
    #"WLR_DRM_DEVICES" = "/dev/dri/card0:/dev/dri/card1";
    "__NV_PRIME_RENDER_OFFLOAD" = "1";
    "__VK_LAYER_NV_optimus" = "NVIDIA_only";
    # Fix common issues
   # "LIBGL_DRI3_DISABLE" = "1";
  };
}
