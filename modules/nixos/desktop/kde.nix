# Optional KDE Plasma 6 session. Enable per host: my.desktop.kde.enable = true;
{ config, lib, ... }:

{
  options.my.desktop.kde.enable = lib.mkEnableOption "the KDE Plasma 6 session";

  config = lib.mkIf config.my.desktop.kde.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
