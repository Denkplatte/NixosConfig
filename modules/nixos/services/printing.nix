{ ... }:

{
  services.printing.enable = true;

  # Printer discovery on the local network.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # CUPS (IPP) for sharing / network printing.
  networking.firewall.allowedTCPPorts = [ 631 ];
}
