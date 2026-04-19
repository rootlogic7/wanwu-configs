{ config, inputs, ... }: {
  imports = [
    # 1. Globale und Profil-spezifische Module
    ../../modules/core
    ../../modules/profiles/workstation.nix
    
    # 2. Hardware-Features (Spezifisch für die Workstation)
    ../../modules/hardware/zfs-rollback.nix
    ../../modules/hardware/nvidia.nix

    # 3. Opt-in Features
    ../../modules/features/cli/nushell
    ../../modules/features/desktop/niri
    ../../modules/features/apps/ghostty
    ../../modules/features/apps/neovim

    # 4. Host-spezifische Hardwaredaten
    ./disko.nix
    # ./hardware-configuration.nix
  ];

  # ===========================================================================
  # BASIS-KONFIGURATION
  # ===========================================================================
  mainUser = "haku";
  networking.hostName = "workstation";

  # ===========================================================================
  # DATEISYSTEME & PERSISTENZ
  # ===========================================================================
  boot.supportedFilesystems = [ "zfs" "btrfs" ];
  networking.hostId = "4e98920d"; # TODO: Generiere eine 8-stellige ID mit `head -c 8 /etc/machine-id`

  # Impermanence-Fix: Teilt dem Bootloader mit, dass /home früh gemountet werden muss
  fileSystems."/home".neededForBoot = true;

  custom.hardware.zfs-rollback = {
    enable = true;
    pool = "rpool";
  };

  # ===========================================================================
  # HARDWARE
  # ===========================================================================
  custom.hardware.nvidia.enable = true;

  # ===========================================================================
  # FEATURES
  # ===========================================================================
  features.cli.nushell.enable = true;
  features.apps.ghostty.enable = true;
  features.apps.neovim.enable = true;

  features.desktop.niri = {
    enable = true;
    hasTouchpad = false;
    monitorConfig = ''
        output "DP-1" {
            mode "3440x1440@100" // Passe die Hz an
            scale 1.0
            position x=0 y=0
        }
        output "HDMI-A-1" {
            mode "1920x1080"
            scale 1.0
            position x=3440 y=0
        }
    '';
  };

  system.stateVersion = "26.05";
}
