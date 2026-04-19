{ config, pkgs, lib, ... }:

let cfg = config.features.hardware.laptop;
in {
  options.features.hardware.laptop = {
    enable = lib.mkEnableOption "Laptop specific hardware (Power, Touchpad, Firmware)";
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
    services.thermald.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = false; # TLP Konflikt vermeiden
    
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      };
    };

    services.throttled.enable = true;
    services.libinput.enable = true;
    networking.networkmanager.wifi.backend = "iwd";

    environment.systemPackages = with pkgs; [
      acpi
      powertop
      brightnessctl
    ];
  };
}
