{ config, lib, pkgs, ... }:

{
  imports = [
    ../wayland-base.nix
    ./config.nix
    ./waybar.nix
  ];

  # System-wide Sway enablement
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Essential packages for Sway
  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    wlroots
  ];

  # Make sure login manager knows about Sway
  services.xserver.displayManager.sessionPackages = [ pkgs.sway ];
}
