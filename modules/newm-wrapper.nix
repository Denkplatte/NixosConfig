{ config, lib, pkgs, newm-atha, ... }:

let
  newm-session = pkgs.makeDesktopItem {
    name = "newm";
    desktopName = "NewM";
    comment = "NewM Wayland Compositor";
    exec = "env HOME=/home/las ${newm-atha.packages.${pkgs.system}.newm-atha}/bin/start-newm --config /home/las/.config/newm/config.py";
    #exec = "${newm-atha.packages.${pkgs.system}.newm-atha}/bin/start-newm --config /home/las/.config/newm/config.py";
    type = "Application";
  };

  newm-wrapped = pkgs.symlinkJoin {
    name = "newm-atha-wrapped";
    paths = [ newm-atha.packages.${pkgs.system}.newm-atha ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    passthru.providedSessions = [ "newm" ];
    postBuild = ''
      mkdir -p $out/share/wayland-sessions
      cp ${newm-session}/share/applications/newm.desktop $out/share/wayland-sessions/
    '';
  };
in {
  environment.systemPackages = [ newm-wrapped ];

  # Needed for display manager like tuigreet to list it
  services.xserver.displayManager.sessionPackages = [ newm-wrapped ];
}
