{ pkgs, ... }:

let
  t = import ../../theme/hotline-miami.nix;
in
{
  programs.kitty = {
    enable = true;

    font = {
      name = "Terminus";
      size = 11;
    };

    settings = {
      background            = t.bg;
      foreground            = t.fg;
      selection_background  = t.pink;
      selection_foreground  = t.bg;
      cursor                = t.pink;
      cursor_text_color     = t.bg;
      url_color             = t.cyanBr;

      color0  = t.black;
      color8  = t.blackBr;
      color1  = t.red;
      color9  = t.redBr;
      color2  = t.green;
      color10 = t.greenBr;
      color3  = t.yellowAnsi;
      color11 = t.yellowBr;
      color4  = t.blue;
      color12 = t.blueBr;
      color5  = t.magenta;
      color13 = t.magentaBr;
      color6  = t.cyanAnsi;
      color14 = t.cyanBr;
      color7  = t.white;
      color15 = t.whiteBr;

      window_padding_width    = 12;
      hide_window_decorations = "yes";
      background_opacity      = "0.97";

      tab_bar_style           = "powerline";
      tab_powerline_style     = "angled";
      active_tab_background   = t.pink;
      active_tab_foreground   = t.bg;
      inactive_tab_background = t.bgAlt;
      inactive_tab_foreground = t.fgMuted;

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
