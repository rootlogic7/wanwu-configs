{ config, pkgs, ... }: {
  # ===========================================================================
  # BOOTLOADER BASIS
  # ===========================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Hier kannst du später Dinge hinzufügen wie:
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.plymouth.enable = true;
}
