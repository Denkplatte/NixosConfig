{ pkgs, ... }:

let
  t = import ../../theme/hotline-miami.nix;
in
{
  # superfile is already in system packages — just drop the theme config
  home.file.".config/superfile/config.toml".text = ''
    [ui]
    border_style    = "double"
    transparent     = false

    [theme]
    # Hotline Miami
    bg              = ""
    sidebar_bg      = ""
    box_background  = ""

    border          = "${t.pinkDim}"
    selected_item   = "${t.pink}"
    focused_border  = "${t.pink}"
    unfocused_border = "${t.bgAlt}"

    directory_icon_color  = "${t.cyan}"
    file_icon_color       = "${t.fg}"
    selected_icon_color   = "${t.pink}"

    [general]
    default_open_command = "xdg-open"
    terminal             = "kitty"
  '';
}
