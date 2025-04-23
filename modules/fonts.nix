{ config, lib, pkgs, ... }:

{
  # System-wide font configuration
  fonts = {
    enableDefaultPackages = true;  # Include common font packages like DejaVu, Liberation, etc.
    fontDir.enable = true;         # Make fonts available to X11/Wayland
    packages = with pkgs; [
      terminus_font            # TUI-friendly bitmap font
      jetbrains-mono           # Great for coding
      noto-fonts               # Full unicode coverage
      noto-fonts-cjk           # Chinese/Japanese/Korean
      noto-fonts-emoji         # Color emoji
      font-awesome             # Icons for waybar/polybar etc.
      nerdfonts                # All-in-one patch set (many glyphs/icons)
    ];
  };
}
