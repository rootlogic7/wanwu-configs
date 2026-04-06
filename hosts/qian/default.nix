{ ... }: {
  imports = [
    ./disko.nix
    # ./hardware-configuration.nix
    ../../modules/common
    ../../modules/profiles/workstation.nix
    ../../modules/hardware/zfs-rollback.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/desktops/niri.nix
  ];

  mainUser = "haku";

  networking.hostName = "workstation";
  networking.hostId = "1234abcd";
  
  # Spezifisch für Qians ZFS-Layout
  boot.supportedFilesystems = [ "zfs" "btrfs" ];

  custom.hardware.zfs-rollback = {
    enable = true;
    pool = "rpool";
  };

  custom.hardware.nvidia.enable = true;

  home-manager.users.${config.mainUser} = {
    custom.niri = {
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
  };

  system.stateVersion = "26.05";
}
