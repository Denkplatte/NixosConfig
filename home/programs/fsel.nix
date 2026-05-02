{pkgs, ...}:

{

 xdg.desktopEntries.fsel = {
    name = "fsel";
    exec = "kitty --class fsel -e fsel";
    terminal = false;
    type = "Application";
    categories = [ "System" ];
  };


home.file.".config/fsel/config.toml".text = ''
  terminal_launcher = "kitty -e"

  [app_launcher]
  filter_desktop = true
  match_mode = "fuzzy"
'';

 home.packages = [
    (pkgs.writeShellScriptBin "unreal-launcher" ''
    #!/bin/sh
    steam-run /home/las/Downloads/Linux_Unreal_Engine_5.6.1/Engine/Binaries/Linux/UnrealEditor
  '')
  ];

home.file.".local/share/applications/unreal-engine.desktop".text = ''
  [Desktop Entry]
  Name=Unreal Engine Editor
  Exec=/home/las/.local/bin/launch-unreal
  Type=Application
  Categories=Development;
  Terminal=false
'';

}
