{config, pkgs, ... }:

{
  # System-wide font configuration
   fonts.packages = with pkgs; [
      terminus_font            # TUI-friendly bitmap font
      jetbrains-mono           # Great for coding
      noto-fonts               # Full unicode coverage
      noto-fonts-color-emoji         # Color emoji
      font-awesome             # Icons for waybar/polybar etc.
      nerd-fonts.droid-sans-mono                # All-in-one patch set (many glyphs/icons)
    ];
}
