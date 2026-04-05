{ ... }: {
  imports = [
    ../../modules/common
    ../../modules/profiles/workstation.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/desktops/niri.nix
    ./disko.nix
    # ./hardware-configuration.nix
  ];
  mainUser = "haku";
  custom.hardware.nvidia.enable = true;

  networking.hostName = "workstation";
  networking.hostId = "1234abcd";
  
  # Spezifisch für Qians ZFS-Layout
  boot.supportedFilesystems = [ "zfs" "btrfs" ];

  system.stateVersion = "26.05";
}
