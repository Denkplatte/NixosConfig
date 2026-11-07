# Denkplatte: everything that is specific to THIS machine lives here.
{ ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Legacy BIOS boot with GRUB on the first disk.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  # Intel + NVIDIA laptop (PRIME sync). Find bus IDs with: lspci | grep -E 'VGA|3D'
  my.nvidia = {
    enable = true;
    prime = {
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:4:0:0";
    };
  };

  # Optional extra desktops (login screen lets you pick the session).
  # my.desktop.gnome.enable = true;
  # my.desktop.kde.enable = true;

  # Release of the first install. Do NOT change on an existing machine.
  system.stateVersion = "24.11";
}
