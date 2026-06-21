{ pkgs, ... }:

{

  home.packages = [
    (pkgs.writeShellScriptBin "launch-btop" ''
      exec kitty --class btop btop
    '')
  ];

  # This tells Home Manager to generate custom .desktop files
  # and place them in your ~/.local/share/applications/
  home.file.".local/share/applications/btop.desktop".text = ''
    [Desktop Entry]
    Name=Btop++
    Exec=launch-btop
    Type=Task Manager
    Categories=System;
    Terminal=false
  '';

    # 2. FIXING UNREAL ENGINE
    # Unreal often needs to be wrapped in an FHS or run from a specific path.
    # Replace the exec path with your actual Unreal Engine FHS wrapper script.
     home.packages = [
    (pkgs.writeShellScriptBin "unreallauncher" ''
      exec ${pkgs.steam-run}/bin/steam-run /home/las/Downloads/Linux_Unreal_Engine_5.6.1/Engine/Binaries/Linux/UnrealEditor
    '')
  ];

  home.file.".local/share/applications/unreal-engine.desktop".text = ''
    [Desktop Entry]
    Name=Unreal Engine Editor
    Exec=unreallauncher
    Type=Application
    Categories=Development;
    Terminal=false
  '';

  
}
