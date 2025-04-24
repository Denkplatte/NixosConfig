{ config, pkgs, lib, ... }:

{
  options.enableHyprland = lib.mkEnableOption "Enable Hyprland setup";

  config = lib.mkIf config.enableHyprland {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  services.xserver.displayManager.sessionPackages = [ pkgs.hyprland];
}
