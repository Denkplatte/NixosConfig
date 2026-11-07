{ theme, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "Terminus";
      size = 11;
    };

    settings = {
      background            = theme.bg;
      foreground            = theme.fg;
      selection_background  = theme.pink;
      selection_foreground  = theme.bg;
      cursor                = theme.pink;
      cursor_text_color     = theme.bg;
      url_color             = theme.cyanBr;

      color0  = theme.black;
      color8  = theme.blackBr;
      color1  = theme.red;
      color9  = theme.redBr;
      color2  = theme.green;
      color10 = theme.greenBr;
      color3  = theme.yellowAnsi;
      color11 = theme.yellowBr;
      color4  = theme.blue;
      color12 = theme.blueBr;
      color5  = theme.magenta;
      color13 = theme.magentaBr;
      color6  = theme.cyanAnsi;
      color14 = theme.cyanBr;
      color7  = theme.white;
      color15 = theme.whiteBr;

      window_padding_width    = 12;
      hide_window_decorations = "yes";
      background_opacity      = "0.97";

      tab_bar_style           = "powerline";
      tab_powerline_style     = "angled";
      active_tab_background   = theme.pink;
      active_tab_foreground   = theme.bg;
      inactive_tab_background = theme.bgAlt;
      inactive_tab_foreground = theme.fgMuted;

      enable_audio_bell        = "no";
      cursor_shape             = "block";
      cursor_blink_interval    = "0";
      scrollback_lines         = 10000;
      copy_on_select           = "yes";
      confirm_os_window_close  = 0;
    };

    keybindings = {
      "ctrl+shift+t"     = "new_tab_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+c"     = "copy_to_clipboard";
      "ctrl+shift+v"     = "paste_from_clipboard";
    };
  };
}
