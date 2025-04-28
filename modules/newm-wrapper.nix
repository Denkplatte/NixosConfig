{ config, lib, pkgs, newm-atha, ... }:

let
  newm-session = pkgs.makeDesktopItem {
    name = "newm";
    desktopName = "NewM";
    comment = "NewM Wayland Compositor";
    exec = "${newm-atha.packages.${pkgs.system}.newm-atha}/bin/start-newm";
    type = "Application";
  };

  newm-wrapped = pkgs.symlinkJoin {
    name = "newm-atha-wrapped";
    paths = [ newm-atha.packages.${pkgs.system}.newm-atha ];
    buildInputs = [ pkgs.makeWrapper ];
    passthru.providedSessions = [ "newm" ];
    postBuild = ''
      mkdir -p $out/share/wayland-sessions
      mkdir -p $out/share/xsessions
      cp ${newm-session}/share/applications/newm.desktop $out/share/wayland-sessions/
      cp ${newm-session}/share/applications/newm.desktop $out/share/xsessions/
    '';
  };
in {
  environment.systemPackages = [ newm-wrapped ];
  services.xserver.displayManager.sessionPackages = [ newm-wrapped ];
}
