{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.nvidia;
in {
  options.custom.hardware.nvidia = {
    enable = lib.mkEnableOption "Proprietary Nvidia Drivers and Wayland tweaks";
  };

  config = lib.mkIf cfg.enable {
    # 1. Unfree Packages für Nvidia erlauben
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

    # 2. Kernel-Module und Parameter
    boot.kernelParams = [ "nvidia-drm.fbdev=1" ]; # Wichtig für Wayland/Niri
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    # 3. Grafik-Treiber (hardware.graphics ersetzt hardware.opengl)
    hardware.graphics = {
      enable = true;
      enable32Bit = true; # Wichtig für Steam/Gaming
    };

    # Xserver anweisen, den Nvidia-Treiber zu laden
    services.xserver.videoDrivers = [ "nvidia" ];

    # 4. Nvidia-spezifische Konfiguration
    hardware.nvidia = {
      modesetting.enable = true; # PFLICHT für Wayland/Hyprland/Niri
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      
      open = true; # Open-Source Kernel Module
      nvidiaSettings = true;
      
      # Zwingend den aktuellsten Treiber nutzen (wichtig für neuere Karten wie RTX 5000 Serie)
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    # 5. Systemweite Environment-Variablen für Wayland + Nvidia
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct"; 
    };
  };
}
