# Proprietary NVIDIA driver. Off by default; enable per host:
#   my.nvidia.enable = true;
#   my.nvidia.prime = { intelBusId = "PCI:0:2:0"; nvidiaBusId = "PCI:1:0:0"; };
{ config, lib, pkgs, ... }:

let
  cfg = config.my.nvidia;
  busId = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    example = "PCI:0:2:0";
  };
in
{
  options.my.nvidia = {
    enable = lib.mkEnableOption "the proprietary NVIDIA driver";
    prime = {
      intelBusId  = busId;
      nvidiaBusId = busId;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics.extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;        # also sets nvidia-drm.modeset=1
      powerManagement.enable = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = false;
      nvidiaSettings = true;

      # Hybrid Intel+NVIDIA: only when both bus IDs are given.
      prime = lib.mkIf (cfg.prime.intelBusId != null && cfg.prime.nvidiaBusId != null) {
        sync.enable = true;
        inherit (cfg.prime) intelBusId nvidiaBusId;
      };
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS   = "1";
      LIBVA_DRIVER_NAME         = "nvidia";
      GBM_BACKEND               = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
