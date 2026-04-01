{ ... }: {
  imports = [
    ../../modules/common
    ../../modules/profiles/workstation.nix
    ../../modules/desktops/niri.nix
    ./disko.nix
    # ./hardware-configuration.nix
  ];

  networking.hostName = "qian";
  networking.hostId = "1234abcd";
  
  # Spezifisch für Qians ZFS-Layout
  boot.supportedFilesystems = [ "zfs" "btrfs" ];

  system.stateVersion = "26.05";
}
