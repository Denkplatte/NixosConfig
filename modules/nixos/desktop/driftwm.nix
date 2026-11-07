# driftwm compositor, available as a session on the login screen.
{ inputs, pkgs, ... }:

let
  driftwm = inputs.driftwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  environment.systemPackages = [ driftwm ];
  services.displayManager.sessionPackages = [ driftwm ];
}
