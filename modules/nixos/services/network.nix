{ pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };

  environment.systemPackages = [ pkgs.openvpn ];
}
