{ inputs, config, ... }: {
  imports = [
    # 1. Globale und Profil-spezifische Module
    ../../modules/core
    ../../modules/profiles/laptop.nix
    ../../modules/desktop/niri.nix
    
    # 2. Hardware-Features (Neu: Unser abstrahiertes Btrfs-Modul)
    ../../modules/hardware/btrfs-rollback.nix

    # 3. Host-spezifische Hardwaredaten
    ./disko.nix
    ./hardware-configuration.nix
  ];

  # ===========================================================================
  # BASIS-KONFIGURATION
  # ===========================================================================
  mainUser = "haku";
  networking.hostName = "thinkpad";

  # Nix-Settings (Nur Thinkpad-spezifische Overrides. GC und Optimise-Store kommen aus common/core.nix)
  nix.settings = {
    max-jobs = 2;
    cores = 2;
  };
  
  # ===========================================================================
  # DATEISYSTEME & PERSISTENZ
  # ===========================================================================
  boot.supportedFilesystems = [ "btrfs" ];
  boot.tmp.useTmpfs = false;

  # Aktiviert das neue Rollback-Modul
  custom.hardware.btrfs-rollback = {
    enable = true;
    device = "/dev/mapper/cryptroot";
  };

  # ===========================================================================
  # SWAP & HIBERNATION
  # ===========================================================================
  swapDevices = [ {
    device = "/swap/swapfile";
    size = 8192; # 8 GB
  } ];
  boot.resumeDevice = "/dev/mapper/cryptroot";
  boot.kernelParams = [ "resume_offset=1099815" ];

  system.stateVersion = "26.05";
}
