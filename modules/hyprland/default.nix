#{ config, pkgs, lib, ... }:

#{
#  options.enableHyprland = lib.mkEnableOption "Enable Hyprland setup";

##  config = lib.mkIf config.programs.enableHyprland {
 #   programs.hyprland = {
 #     enable = true;
 #     xwayland.enable = true;
 #   };

#    services.xserver.displayManager.sessionPackages = [ pkgs.hyprland];
#  };

 
#}



#{ config, pkgs, lib, ... }:


#{
#  imports = [
#    ../wayland-base.nix
    #./config.nix
    #./waybar.nix
#  ];


 # config = lib.mkIf config.programs.hyprland.enable {
 #   programs.hyprland.xwayland.enable = true;
 #   services.xserver.displayManager.sessionPackages = [ pkgs.hyprland ];
 # };
#}



#{ config, pkgs, lib, ... }:

#{
#  imports = [
#    ../wayland-base.nix
    # ./config.nix
    # ./waybar.nix
#  ];

 # options.enableHyprland = lib.mkEnableOption "Enable Hyprland setup";

 # config = lib.mkIf config.enableHyprland {
 #   programs.hyprland = {
 #     enable = true;
 #     xwayland.enable = true;
 #   };
 # };

  # 👇 This must be outside the mkIf block so it always adds the session entry
 # services.xserver.displayManager.sessionPackages = [ pkgs.hyprland ];
#}




{ config, pkgs, lib, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.xserver.displayManager.sessionPackages = [ pkgs.hyprland ];
}
