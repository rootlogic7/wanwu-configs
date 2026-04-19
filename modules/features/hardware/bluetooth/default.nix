{ config, pkgs, lib, ... }:

let cfg = config.features.hardware.bluetooth;
in {
  options.features.hardware.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support with Blueman GUI";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true; # Akkustand der Kopfhörer
    };
    services.blueman.enable = true;
  };
}
