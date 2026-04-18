{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "Terminus";
      size = 11;
    };

    settings = {
      # Hotline Miami palette
      background            = "#0d0d0d";
      foreground            = "#e8e0d5";
      selection_background  = "#ff2d78";
      selection_foreground  = "#0d0d0d";
      cursor                = "#ff2d78";
      cursor_text_color     = "#0d0d0d";
      url_color             = "#00e5cc";

      # Black
      color0  = "#1a1a1a";
      color8  = "#3d3d3d";
      # Red → hot pink
      color1  = "#ff2d78";
      color9  = "#ff5c9a";
      # Green → cyan
      color2  = "#00e5cc";
      color10 = "#33ecd6";
      # Yellow
      color3  = "#f5c400";
      color11 = "#f7d133";
      # Blue → deep pink
      color4  = "#cc1f5f";
      color12 = "#ff2d78";
      # Magenta → orange
      color5  = "#ff6b1a";
      color13 = "#ff8c4a";
      # Cyan → bright cyan
      color6  = "#00c4af";
      color14 = "#00e5cc";
      # White
      color7  = "#e8e0d5";
      color15 = "#ffffff";

      # Window
      window_padding_width    = 12;
      hide_window_decorations = "yes";
      background_opacity      = "0.97";

      # Tabs (for when you use them)
      tab_bar_style          = "powerline";
      tab_powerline_style    = "angled";
      active_tab_background  = "#ff2d78";
      active_tab_foreground  = "#0d0d0d";
      inactive_tab_background = "#161616";
      inactive_tab_foreground = "#555555";

      # Misc
      enable_audio_bell  = "no";
      visual_bell_duration = "0.0";
      cursor_shape       = "block";
      cursor_blink_interval = "0";
      scrollback_lines   = 10000;
      copy_on_select     = "yes";
    };

    keybindings = {
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };
}
