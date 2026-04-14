{ ... }: {
  imports = [
    ../../modules/common
    ../../modules/profiles/workstation.nix
    ../../modules/desktop/niri.nix

    ./disko.nix
    # ./hardware-configuration.nix

    # ===TODO===
    ../../modules/hardware/zfs-rollback.nix
    ../../modules/hardware/nvidia.nix
  ];

  # General
  mainUser = "haku";
  networking.hostName = "workstation";


  # Filesystems
  boot.supportedFilesystems = [ "zfs" "btrfs" ];
  networking.hostId = "";

  custom.hardware.zfs-rollback = {
    enable = true;
    pool = "rpool";
  };

  custom.hardware.nvidia.enable = true;

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.${config.mainUser} = {
      imports = [
        ../../modules/home/haku.nix
      ];

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
  };

  system.stateVersion = "26.05";
}
