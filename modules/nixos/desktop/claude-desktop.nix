# Claude Desktop (https://github.com/patrickjaja/claude-desktop-extra)
{ inputs, pkgs, ... }:

{
  imports = [ inputs.claude-desktop.nixosModules.default ];

  environment.systemPackages = [
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Keeps the Claude sign-in outside of GNOME; unlocked at login via greetd.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Only needed for the *local* Cowork VM (cloud Cowork works without it):
  # programs.claude-desktop-extra.kvmAccess.enable = true;
}
