{ inputs, config, ... }: {
  imports = [
    # 1. Globale und Profil-spezifische Module
    ../../modules/core
    ../../modules/profiles/laptop.nix    
    # 2. Hardware-Features (Neu: Unser abstrahiertes Btrfs-Modul)
    ../../modules/hardware/btrfs-rollback.nix

    # Features
    ../../modules/features/cli/nushell
    ../../modules/features/desktop/niri

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

  # ===========================================================================
  # Features
  # ==========================================================================
  features.cli.nushell.enable = true;

  # NEU: Niri aktivieren und konfigurieren (Diesen Block hast du vorher umständlich im home-manager Block definiert!)
  features.desktop.niri = {
    enable = true;
    hasTouchpad = true;
    monitorConfig = ''
      output "eDP-1" {
          mode "1366x768"
          scale 0.8
      }
    '';
  };
  system.stateVersion = "26.05";
}
