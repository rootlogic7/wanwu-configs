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
  custom.hardware.nvidia.enable = true;
  custom.hardware.zfs-rollback = {
    enable = true;
    pool = "rpool";
  };

  networking.hostName = "workstation";
  networking.hostId = "1234abcd";
  
  # Spezifisch für Qians ZFS-Layout
  boot.supportedFilesystems = [ "zfs" "btrfs" ];

  system.stateVersion = "26.05";
}
