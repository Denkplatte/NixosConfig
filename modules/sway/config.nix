{ config, lib, pkgs, ... }:

{
  # Optional system-wide Sway configuration
  environment.etc."sway/config.d/default".text = ''
    # System-wide Sway settings (applies to all users)
    # This is minimal as most config should be in home-manager
    
    # Enable touchpad gestures
    input type:touchpad {
      tap enabled
      natural_scroll enabled
    }
  '';
}
