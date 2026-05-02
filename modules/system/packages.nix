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
   tuigreet     
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
   fuzzel
   xwayland-satellite
   networkmanager
   fzf
   boxes
   ffmpeg_7-full
   kitty
   alacritty
   tuifimanager
   superfile
   grim
   slurp
   brightnessctl
   adwaita-icon-theme
   wiremix
   impala

  ];
}
