# Optional GNOME session. Enable per host: my.desktop.gnome.enable = true;
{ config, lib, ... }:

{
  options.my.desktop.gnome.enable = lib.mkEnableOption "the GNOME desktop session";

  config = lib.mkIf config.my.desktop.gnome.enable {
    services.desktopManager.gnome.enable = true;
  };
}
