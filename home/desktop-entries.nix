{ pkgs, ... }:

{
  # This tells Home Manager to generate custom .desktop files
  # and place them in your ~/.local/share/applications/
  xdg.desktopEntries = {

    # 1. FIXING BTOP
    # We override the btop entry to explicitly force Kitty to launch it,
    # bypassing dex's terminal confusion.
    btop = {
      name = "Btop";
      genericName = "System Monitor";
      exec = "kitty -e btop"; # Explicitly call your terminal!
      terminal = false;       # Set to false because kitty is already spawning a window
      categories = [ "System" "Monitor" ];
      icon = "btop";
    };

    # 2. FIXING UNREAL ENGINE
    # Unreal often needs to be wrapped in an FHS or run from a specific path.
    # Replace the exec path with your actual Unreal Engine FHS wrapper script.
    unreal-engine = {
      name = "Unreal Engine Editor";
      genericName = "Game Engine";
      # Example: Forcing it to run through a custom FHS wrapper script or standard bash
      exec = "unreal-launcher"; 
      terminal = false;
      categories = [ "Development" ];
      icon = "unreal-engine";
    };

  };
}
