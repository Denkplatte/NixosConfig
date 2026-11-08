{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    terminus_font               # TUI-friendly bitmap font
    jetbrains-mono              # coding
    noto-fonts                  # unicode coverage
    noto-fonts-color-emoji      # color emoji
    font-awesome                # waybar icons
    nerd-fonts.droid-sans-mono  # nerd font glyphs
  ];
}
