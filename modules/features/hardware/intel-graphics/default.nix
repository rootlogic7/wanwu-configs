{ config, pkgs, lib, ... }:

let cfg = config.features.hardware.intel-graphics;
in {
  options.features.hardware.intel-graphics = {
    enable = lib.mkEnableOption "Intel Graphics & Hardware Video Acceleration";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
  };
}
