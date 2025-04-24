# modules/default.nix
{ config, lib, pkgs, ... }: {
  imports = [
    ./sway/config.nix
    ./sway/default.nix
    ./sway/waybar.nix

        
  ];
}
