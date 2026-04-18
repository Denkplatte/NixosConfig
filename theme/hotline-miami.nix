# Central theme — import this wherever you need colors
# Usage: let theme = import ../../theme/hotline-miami.nix; in ...

{
  bg        = "#1a0a2e";   # dark purple, not pure black
  bgAlt     = "#120720";   # deeper purple for contrast surfaces
  fg        = "#e8e0d5";   # warm off-white
  fgMuted   = "#7a6e8a";   # muted purple-grey

  pink      = "#ff2d78";   # hot pink — primary accent
  pinkDim   = "#cc1f5f";   # darker pink for inactive/borders
  orange    = "#ff6b1a";   # orange — secondary accent
  cyan      = "#00e5cc";   # cyan — highlights, selections
  cyanDim   = "#00c4af";   # dimmer cyan
  yellow    = "#f5c400";   # yellow — warnings, cursor

  # Terminal ANSI slots (for kitty etc.)
  black     = "#1a0a2e";
  blackBr   = "#2e1a4a";
  red       = "#ff2d78";
  redBr     = "#ff5c9a";
  green     = "#00e5cc";
  greenBr   = "#33ecd6";
  yellowAnsi = "#f5c400";
  yellowBr  = "#f7d133";
  blue      = "#cc1f5f";
  blueBr    = "#ff2d78";
  magenta   = "#ff6b1a";
  magentaBr = "#ff8c4a";
  cyanAnsi  = "#00c4af";
  cyanBr    = "#00e5cc";
  white     = "#e8e0d5";
  whiteBr   = "#ffffff";
}
