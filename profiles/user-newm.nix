{ pkgs, ... }:

let
  homeDir = "/home/las";
in
{
  home.username = "las";
  home.homeDirectory = homeDir;

  home.file."wayland-env.sh".text = ''
    #!/bin/sh
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=wlroots
    export XDG_CURRENT_DESKTOP=wlroots
    export XDG_CURRENT_SESSION=wlroots
    export TDESKTOP_DISABLE_GTK_INTEGRATION=1
    export CLUTTER_BACKEND=wayland
    export BEMENU_BACKEND=wayland
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland-egl
    export QT_WAYLAND_FORCE_DPI=physical
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export ELM_DISPLAY=wl
    export ECORE_EVAS_ENGINE=wayland_egl
    export ELM_ENGINE=wayland_egl
    export ELM_ACCEL=opengl
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export NO_AT_BRIDGE=1
    export WINIT_UNIX_BACKEND=wayland
  '';

  home.file."newm-run.sh" = {
    text = ''
      #!/bin/sh
      source "${homeDir}/wayland-env.sh"
      sleep 0.5
      exec start-newm
    '';
    executable = true;
  };


  # Deploy the NewM config to the user's config directory
  home.file.".config/newm/config.py".text = ''
    from __future__ import annotations
    from typing import Callable, Any

    import os
    import pwd
    import time
    import logging

    from newm.layout import Layout
    from newm.helper import BacklightManager, WobRunner, PaCtl

    from pywm import (
        PYWM_MOD_LOGO,
        PYWM_MOD_ALT
    )

    logger = logging.getLogger(__name__)

    background = {
        'path': '/home/las/Downloads/miami.jpg',
        'anim': True
    }

    outputs = [
        { 'name': 'eDP-1' },
        { 'name': 'virt-1', 'pos_x': -1280, 'pos_y': 0, 'width': 1280, 'height': 720 }
    ]

    wob_runner = WobRunner("wob -a bottom -M 100")
    backlight_manager = BacklightManager(anim_time=1., bar_display=wob_runner)
    kbdlight_manager = BacklightManager(args="--device='*::kbd_backlight'", anim_time=1., bar_display=wob_runner)

    def synchronous_update() -> None:
        backlight_manager.update()
        kbdlight_manager.update()

    pactl = PaCtl(0, wob_runner)


    focus = {
        'enabled': True,
        'color' :'#FF000095',
        'distance': 4,
        'animate_on_change': True,
        'width' : 2,
        'anim_time' : 0.2
    } 


    def key_bindings(layout: Layout) -> list[tuple[str, Callable[[], Any]]]:
        return [
            ("L-h", lambda: layout.move(-1, 0)),
            ("L-j", lambda: layout.move(0, 1)),
            ("L-k", lambda: layout.move(0, -1)),
            ("L-l", lambda: layout.move(1, 0)),
            ("L-u", lambda: layout.basic_scale(1)),
            ("L-n", lambda: layout.basic_scale(-1)),
            ("L-t", lambda: layout.move_in_stack(1)),

            ("L-H", lambda: layout.move_focused_view(-1, 0)),
            ("L-J", lambda: layout.move_focused_view(0, 1)),
            ("L-K", lambda: layout.move_focused_view(0, -1)),
            ("L-L", lambda: layout.move_focused_view(1, 0)),

            ("L-C-h", lambda: layout.resize_focused_view(-1, 0)),
            ("L-C-j", lambda: layout.resize_focused_view(0, 1)),
            ("L-C-k", lambda: layout.resize_focused_view(0, -1)),
            ("L-C-l", lambda: layout.resize_focused_view(1, 0)),

            ("L-Return", lambda: os.system("alacritty &")),

            ("L-r", lambda: os.system("bemenu-run &")),

            ("L-q", lambda: layout.close_focused_view()),

            ("L-p", lambda: layout.ensure_locked(dim=True)),
            ("L-P", lambda: layout.terminate()),
            ("L-C", lambda: layout.update_config()),

            ("L-f", lambda: layout.toggle_fullscreen()),
            ("L-", lambda: layout.toggle_overview()),

            ("XF86MonBrightnessUp", lambda: backlight_manager.set(backlight_manager.get() + 0.1)),
            ("XF86MonBrightnessDown", lambda: backlight_manager.set(backlight_manager.get() - 0.1)),
            ("XF86KbdBrightnessUp", lambda: kbdlight_manager.set(kbdlight_manager.get() + 0.1)),
            ("XF86KbdBrightnessDown", lambda: kbdlight_manager.set(kbdlight_manager.get() - 0.1)),
            ("XF86AudioRaiseVolume", lambda: pactl.volume_adj(5)),
            ("XF86AudioLowerVolume", lambda: pactl.volume_adj(-5)),
            ("XF86AudioMute", lambda: pactl.mute()),
        ]

    panels = {
        'lock': {
            'cmd': 'alacritty -e newm-panel-basic lock',
        },
        'launcher': {
            'cmd': 'alacritty -e newm-panel-basic launcher'
        },
        'top_bar': {
            'native': {
                'enabled': True,
                'texts': lambda: [
                    pwd.getpwuid(os.getuid())[0],
                    time.strftime("%c"),
                ],
            }
        },
        'bottom_bar': {
            'native': {
                'enabled': True,
                'texts': lambda: [
                    "newm",
                    "powered by pywm"
                ],
            }
        },
    }

    energy = {
        'idle_callback': backlight_manager.callback
    }
  '';
}
