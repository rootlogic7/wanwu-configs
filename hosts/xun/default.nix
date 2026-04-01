{ inputs, ... }: {
  imports = [
    ../../modules/common
    ../../modules/profiles/laptop.nix
    ../../modules/desktop/niri.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];


  # ===========================================================================
  # HARDWARE-SPEZIFISCHE MANIFESTATION (XUN)
  # ===========================================================================
  networking.hostName = "xun";
  
  boot.supportedFilesystems = [ "btrfs" ];


  # ===========================================================================
  # NIX DAEMON OPTIMIERUNG (Für Low-RAM / Ältere CPUs)
  # ===========================================================================
  nix.settings = {
    # Beschränkt parallele Build-Jobs auf 2
    max-jobs = 2;
    # Jeder Build-Job darf maximal 2 CPU-Kerne nutzen
    cores = 2;
  };

  # Extrem wichtig für Maschinen mit <= 8GB RAM!
  # Verhindert, dass /tmp im Arbeitsspeicher (tmpfs) gemountet wird, 
  # was bei großen Builds unweigerlich zu OOM-Crashes führt.
  boot.tmp.useTmpfs = false;


  # ===========================================================================
  # BTRFS ROLLBACK SCRIPT (Erase your Darlings)
  # ===========================================================================
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.services.btrfs-rollback = {
    description = "Rollback Btrfs root subvolume to a pristine state";
    wantedBy = [ "initrd.target" ];
    after = [ "systemd-cryptsetup@cryptroot.service" ]; # Warten bis LUKS offen ist
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    
    script = ''
      mkdir -p /btrfs_tmp
      mount -o subvol=/ /dev/mapper/cryptroot /btrfs_tmp

      if [ -d "/btrfs_tmp/root" ]; then
          # Lösche erst alle verschachtelten Subvolumes
          btrfs subvolume list -o /btrfs_tmp/root |
          cut -f9 -d' ' |
          while read subvolume; do
              btrfs subvolume delete "/btrfs_tmp/$subvolume"
          done &&
          btrfs subvolume delete /btrfs_tmp/root
      fi

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };


  # ===========================================================================
  # SWAP & HIBERNATION (8 GB RAM)
  # ===========================================================================
  swapDevices = [ {
    device = "/swap/swapfile";
    size = 8192; # 8 GB = 8192 MB
  } ];

  # Das Gerät, auf dem sich Btrfs und damit das Swapfile befindet (LUKS Container)
  boot.resumeDevice = "/dev/mapper/cryptroot";

  # WICHTIG FÜR BTRFS HIBERNATION:
  # Der resume_offset muss nach der Erstinstallation ermittelt und hier eingetragen werden!
  boot.kernelParams = [ "resume_offset=1099815" ];


  # ===========================================================================
  # HOME MANAGER KONFIGURATION
  # ===========================================================================
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    
    # Hier weisen wir Home Manager an, deine Datei zu laden!
    users.zhenren = import ../../modules/home/zhenren.nix;
  };

  system.stateVersion = "26.05";
}
