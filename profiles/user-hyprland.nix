{ config, pkgs, lib, ... }:

{
 
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      exec-once = [
        "waybar"
        "alacritty"
        ];

      env = [
        "WLR_NO_HARDWARE_CURSORS,1"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "__GL_VRR_ALLOWED,1"
        "LIBVA_DRIVER_NAME,nvidia"
      ];

      input = {
        kb_layout = "de";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "master";
        #no_cursor_warps = true;
      };

      decoration = {
        rounding = 8;
       # blur = true;
      };

      animations = {
        enabled = true;
      };

      windowrulev2 = [
        "float,class:.*"
        "center,class:.*"
      ];

      bind = [
        "SUPER,RETURN,exec,alacritty"
        "SUPER,Q,killactive,"
        "SUPER,M,exit,"
        "SUPER,D,exec,bemenu-run"
        "SUPER,F,fullscreen,"
        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"
      ];

      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];
    };
  };

  #services.wl-clipboard.enable = true;
}
