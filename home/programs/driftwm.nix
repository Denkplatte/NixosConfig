{ pkgs, ... }:

let
  t = import ../../theme/hotline-miami.nix;
in
{
  # Autostart waybar when driftwm launches
  home.file.".config/driftwm/config.toml".text = ''
    mod_key = "super"
    focus_follows_mouse = true

    autostart = [
      "waybar",
   ]

    [env]
    MOZ_ENABLE_WAYLAND = "1"
    QT_QPA_PLATFORM = "wayland"
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"
    SDL_VIDEODRIVER = "wayland"
    GDK_BACKEND = "wayland"
    ELECTRON_OZONE_PLATFORM_HINT = "wayland"

    [input.keyboard]
    layout = "de"
    repeat_rate = 30
    repeat_delay = 200
    layout_independent = true

    [input.trackpad]
    tap_to_click = true
    natural_scroll = true
    tap_and_drag = true
    accel_profile = "adaptive"

    [input.mouse]
    accel_profile = "flat"

    [navigation]
    friction = 0.94
    animation_speed = 0.3
    nudge_step = 20
    pan_step = 100.0

    [zoom]
    step = 1.1
    fit_padding = 100.0
    reset_on_new_window = true

    [snap]
    enabled = true
    gap = 8.0
    distance = 24.0
    break_force = 32.0

    [decorations]
    bg_color = "${t.bgAlt}"
    fg_color = "${t.pink}"
    corner_radius = 6

    [effects]
    blur_radius = 2
    blur_strength = 1.1

    [backend]
    wait_for_frame_completion = true
    disable_direct_scanout = true

    [background]
    # uncomment and point to a wallpaper shader or image:
    # shader_path = "~/.config/driftwm/bg.glsl"
    # tile_path = "~/.config/driftwm/wallpaper.png"

    [keybindings]
    # --- core ---
    "mod+return"       = "exec kitty"
    "mod+q"            = "close-window"
    "mod+ctrl+shift+q" = "quit"
    "mod+r"            = "reload-config"

    # --- apps ---
    "mod+d"            = "exec kitty --detach -e fsel -d"
    "mod+e"            = "exec kitty --class superfile -e superfile"
    "mod+b"            = "exec firefox"

    # --- window management ---
    "mod+f"            = "toggle-fullscreen"
    "mod+m"            = "fit-window"
    "mod+c"            = "center-window"
    "mod+x"            = "focus-center"
    "mod+a"            = "home-toggle"
    "mod+w"            = "zoom-to-fit"

    # --- navigation (focus jumps) ---
    "mod+up"           = "center-nearest up"
    "mod+down"         = "center-nearest down"
    "mod+left"         = "center-nearest left"
    "mod+right"        = "center-nearest right"
    "mod+k"            = "center-nearest up"
    "mod+j"            = "center-nearest down"
    "mod+h"            = "center-nearest left"
    "mod+l"            = "center-nearest right"

    # --- nudge window ---
    "mod+shift+up"     = "nudge-window up"
    "mod+shift+down"   = "nudge-window down"
    "mod+shift+left"   = "nudge-window left"
    "mod+shift+right"  = "nudge-window right"
    "mod+shift+k"      = "nudge-window up"
    "mod+shift+j"      = "nudge-window down"
    "mod+shift+h"      = "nudge-window left"
    "mod+shift+l"      = "nudge-window right"

    # --- pan viewport ---
    "mod+ctrl+up"      = "pan-viewport up"
    "mod+ctrl+down"    = "pan-viewport down"
    "mod+ctrl+left"    = "pan-viewport left"
    "mod+ctrl+right"   = "pan-viewport right"
    "mod+ctrl+k"       = "pan-viewport up"
    "mod+ctrl+j"       = "pan-viewport down"
    "mod+ctrl+h"       = "pan-viewport left"
    "mod+ctrl+l"       = "pan-viewport right"

    # --- zoom ---
    "mod+equal"        = "zoom-in"
    "mod+minus"        = "zoom-out"
    "mod+0"            = "zoom-reset"

    # --- canvas bookmarks (quadrants) ---
    "mod+1"            = "go-to -1750 1750"
    "mod+2"            = "go-to 1750 1750"
    "mod+3"            = "go-to 1750 -1750"
    "mod+4"            = "go-to -1750 -1750"

    # --- window cycling ---
    "alt+tab"          = "cycle-windows forward"
    "alt+shift+tab"    = "cycle-windows backward"

    # --- media / hardware keys ---
    "XF86AudioRaiseVolume"  = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    "XF86AudioLowerVolume"  = "spawn wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    "XF86AudioMute"         = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    "XF86MonBrightnessUp"   = "spawn brightnessctl set +5%"
    "XF86MonBrightnessDown" = "spawn brightnessctl set 5%-"

    # --- screenshot ---
    "Print"            = "spawn grim - | wl-copy"
    "shift+Print"      = "spawn grim -g \"$(slurp -d)\" - | wl-copy"

    [mouse.on-window]
    "alt+left"         = "move-window"
    "alt+right"        = "resize-window"
    "alt+middle"       = "fit-window"
    "mod+middle"       = "toggle-fullscreen"

    [mouse.on-canvas]
    "left"             = "pan-viewport"
    "trackpad-scroll"  = "pan-viewport"
    "wheel-scroll"     = "zoom"

    [mouse.anywhere]
    "mod+left"         = "pan-viewport"
    "mod+wheel-scroll" = "zoom"

    [gestures.anywhere]
    "3-finger-swipe"   = "pan-viewport"
    "4-finger-swipe"   = "center-nearest"
    "3-finger-pinch"   = "zoom"
    "4-finger-pinch-in"  = "zoom-to-fit"
    "4-finger-pinch-out" = "home-toggle"

    # --- window rules ---
    [[window_rules]]
    app_id = "fsel"
    opacity = 0.95
    blur = true
    decoration = "none"

    [[window_rules]]
    app_id = "superfile"
    opacity = 0.95
    blur = true

    [[window_rules]]
    app_id = "kitty"
    opacity = 0.97
    blur = true
  '';
}
