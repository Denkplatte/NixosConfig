{ config, pkgs, lib, ... }:

{
  # Enable OpenGL with support for both Intel and NVIDIA
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # Intel HD Graphics 5500 specific packages
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # NVIDIA configuration for GeForce 940M
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    # Configure PRIME for Intel HD Graphics 5500 + GeForce 940M
    prime = {
      # Option 1: Sync mode (NVIDIA always on, renders everything)
      sync.enable = true;
      
      # Option 2: Offload mode (Intel default, NVIDIA on demand)
      # Uncomment these and comment out sync.enable if you prefer battery life over performance
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
      
      # Correct bus IDs from lspci output
      intelBusId = "PCI:0:2:0";  # Intel HD Graphics 5500
      nvidiaBusId = "PCI:4:0:0";  # GeForce 940M
    };
    
    # Appropriate driver for GeForce 940M
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Settings specific to your GPU
    open = false;  # Not supported for 940M
    nvidiaSettings = true;
  };
 
  # Environment variables for Wayland + hybrid graphics
  environment.variables = {
    # NVIDIA + Wayland variables
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    
    # Graphics renderer settings
    "WLR_RENDERER" = "gles2";
    "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
    
    # Point to both GPUs
    "WLR_DRM_DEVICES" = "/dev/dri/card0:/dev/dri/card1";
    
    # Fix common issues
    "LIBGL_DRI3_DISABLE" = "1";
  };
  
  # Create a convenience script for launching newm with all required settings
  system.userActivationScripts.createNewmStartScript = lib.mkIf (config.services.xserver.enable) ''
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/start-newm << 'EOF'
#!/bin/sh

# Basic wayland environment
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=newm
export XDG_CURRENT_DESKTOP=newm

# Force hardware acceleration
export WLR_RENDERER=gles2
export WLR_RENDERER_ALLOW_SOFTWARE=1

# NVIDIA + Wayland specifics
export WLR_NO_HARDWARE_CURSORS=1
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# Critical for NVIDIA Maxwell GPUs with Wayland
export LIBGL_DRI3_DISABLE=1

# For Intel/NVIDIA switching
export WLR_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1

# Qt application settings
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# EGL settings
export EGL_PLATFORM=wayland

# Debug output
export NEWM_DEBUG=1

# Start newm
exec newm
EOF
    chmod +x ~/.local/bin/start-newm
  '';
}
