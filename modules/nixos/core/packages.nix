# System-wide CLI tools and apps. Program-specific packages live next to their
# config (e.g. yazi/superfile in home/programs, kitty via programs.kitty).
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # cli basics
    wget
    nano
    git
    btop
    fzf
    pciutils
    figlet
    lolcat

    # media
    imagemagick
    ffmpeg_7-full
    oculante

    # wayland desktop tools
    xwayland-satellite
    grim
    slurp
    wl-clipboard          # wl-copy, used by the screenshot keybindings
    brightnessctl
    adwaita-icon-theme
    wiremix
    blobdrop
    alacritty

    # graphics / gaming
    mesa-demos
    gamescope

    # misc
    woeusb
    qbittorrent
  ];
}
