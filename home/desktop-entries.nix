{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "launch-btop" ''
      exec kitty --app-id btop btop
    '')

    (pkgs.writeShellScriptBin "unreallauncher" ''
      exec ${pkgs.steam-run}/bin/steam-run /home/las/Downloads/Linux_Unreal_Engine_5.6.1/Engine/Binaries/Linux/UnrealEditor
    '')
  ];

  home.file.".local/share/applications/btop.desktop".text = ''
    [Desktop Entry]
    Name=btop++
    Exec=launch-btop
    Type=Application
    Categories=System;
    Terminal=false
  '';

  home.file.".local/share/applications/unreal-engine.desktop".text = ''
    [Desktop Entry]
    Name=Unreal Engine Editor
    Exec=unreallauncher
    Type=Application
    Categories=Development;
    Terminal=false
  '';
}
