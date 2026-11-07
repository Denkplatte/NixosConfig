# Generic Wayland desktop plumbing (GPU-specific bits live in modules/nixos/hardware).
{ ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.libinput.enable = true;   # touchpad
  programs.xwayland.enable = true;

  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE  = "24";

    MOZ_ENABLE_WAYLAND = "1";

    QT_QPA_PLATFORM                     = "wayland";
    QT_WAYLAND_FORCE_DPI                = "physical";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    TDESKTOP_DISABLE_GTK_INTEGRATION = "1";
    CLUTTER_BACKEND = "wayland";
    BEMENU_BACKEND  = "wayland";

    ELM_DISPLAY       = "wl";
    ECORE_EVAS_ENGINE = "wayland_egl";
    ELM_ENGINE        = "wayland_egl";
    ELM_ACCEL         = "opengl";

    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NO_AT_BRIDGE = "1";
    WINIT_UNIX_BACKEND = "wayland";
  };
}
