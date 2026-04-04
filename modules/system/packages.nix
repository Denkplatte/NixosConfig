{pkgs, ... }:

{ 

environment.systemPackages = with pkgs; [
   wget
   nano
   btop
   git
   figlet
   lolcat
   imagemagick
   greetd.tuigreet     
   libinput
   pulseaudio
   seatd
   mesa
   libdrm
   wlroots
   xwayland
   wayland
   egl-wayland
   pciutils
   libxkbcommon
   mesa-demos
   gamescope
   nix-ld
   dracula-theme
   dracula-icon-theme
   dracula-qt5-theme
   fuzzel
   xwayland-satellite
   networkmanager
   fzf
   boxes
   ffmpeg_7-full
   kitty

  ];
}
