# Home Manager settings that only make sense on Denkplatte.
{ pkgs, ... }:

let
  unrealLauncher = pkgs.writeShellScriptBin "unreallauncher" ''
    exec ${pkgs.steam-run}/bin/steam-run \
      "$HOME/Downloads/Linux_Unreal_Engine_5.6.1/Engine/Binaries/Linux/UnrealEditor" "$@"
  '';
in
{
  home.packages = [ unrealLauncher ];

  xdg.desktopEntries.unreal-engine = {
    name = "Unreal Engine Editor";
    exec = "unreallauncher";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
  };
}
