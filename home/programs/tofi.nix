{ pkgs, ... }:
let
  # Catppuccin Mocha — same palette as yazi.nix, for visual consistency
  # across the "TUI-adjacent" tools (yazi, tofi) as distinct from the
  # Hotline Miami theme used by waybar/kitty/driftwm. If you'd rather
  # unify everything under Hotline Miami instead, say so and I'll swap it.
  c = {
    rosewater = "#f5e0dc";
    flamingo  = "#f2cdcd";
    pink      = "#f5c2e7";
    mauve     = "#cba6f7";
    red       = "#f38ba8";
    maroon    = "#eba0ac";
    peach     = "#fab387";
    yellow    = "#f9e2af";
    green     = "#a6e3a1";
    teal      = "#94e2d5";
    sky       = "#89dceb";
    sapphire  = "#74c7ec";
    blue      = "#89b4fa";
    lavender  = "#b4befe";
    text      = "#cdd6f4";
    subtext1  = "#bac2de";
    subtext0  = "#a6adc8";
    overlay2  = "#9399b2";
    overlay1  = "#7f849c";
    overlay0  = "#6c7086";
    surface2  = "#585b70";
    surface1  = "#45475a";
    surface0  = "#313244";
    base      = "#1e1e2e";
    mantle    = "#181825";
    crust     = "#11111b";
  };
in
{
  programs.tofi = {
    enable = true;
settings = {
      # ── window box (this is the "bubbletea box" look) ──────────────────────
      width  = 700;   # fixed pixels for now — ruling out a percent-sizing bug
      height = 480;
      anchor = "center";

      background-color = c.base;
      corner-radius     = 12;
      border-width      = 2;
      border-color      = c.mauve;
      outline-width     = 0;

      padding-top    = 16;
      padding-bottom = 16;
      padding-left   = 16;
      padding-right  = 16;

      # ── layout ───────────────────────────────────────────────────────────
      horizontal     = false;
      num-results    = 8;
      result-spacing = 4;

      # ── fonts ────────────────────────────────────────────────────────────
      font      = "JetBrains Mono";  # reliable Pango/fontconfig name, unlike Terminus
      font-size = 20;                 # bumped up while we debug sizing

      # ── text colors ──────────────────────────────────────────────────────
      text-color        = c.text;
      prompt-text       = "  ";
      prompt-color      = c.mauve;
      placeholder-color = "${c.overlay1}A8";

      input-color = c.text;

      default-result-color = c.subtext1;

      selection-color                    = c.base;
      selection-background               = c.mauve;
      selection-background-padding       = 8;
      selection-background-corner-radius = 8;
      selection-match-color              = c.peach;

      text-cursor           = true;
      text-cursor-style      = "bar";
      text-cursor-color      = c.mauve;
      text-cursor-thickness  = 2;

      # ── behavior ─────────────────────────────────────────────────────────
      matching-algorithm = "fuzzy";
      hide-cursor        = false;
      drun-launch        = true;   # <- this is what actually launches the app
    
    };
  };
}
