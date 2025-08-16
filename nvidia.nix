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
  environment.sessionVariables = {
  # NVIDIA-specific (critical)
  WLR_NO_HARDWARE_CURSORS = "1";
  LIBVA_DRIVER_NAME = "nvidia";
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  
  # Firefox
  MOZ_ENABLE_WAYLAND = "1";
  
  # Qt environment
  QT_QPA_PLATFORM = "wayland";  # More compatible than wayland-egl
  QT_WAYLAND_FORCE_DPI = "physical";
  QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  
  # GTK environment
  # GDK_BACKEND = "wayland";  # Uncomment only if you're sure
  TDESKTOP_DISABLE_GTK_INTEGRATION = "1";
  CLUTTER_BACKEND = "wayland";
  BEMENU_BACKEND = "wayland";
  
  # Elementary environment
  ELM_DISPLAY = "wl";
  ECORE_EVAS_ENGINE = "wayland_egl";
  ELM_ENGINE = "wayland_egl";
  ELM_ACCEL = "opengl";
  
  # SDL environment
  SDL_VIDEODRIVER = "wayland";
  
  # Java environment
  _JAVA_AWT_WM_NONREPARENTING = "1";
  
  # Other settings
  NO_AT_BRIDGE = "1";
  WINIT_UNIX_BACKEND = "wayland";
 };
}
