{ inputs, config, ... }: {
  imports = [
    ../../modules/common
    ../../modules/profiles/laptop.nix
    ../../modules/desktop/niri.nix

    ./disko.nix
    ./hardware-configuration.nix
  ];

  # General
  mainUser = "haku";
  networking.hostName = "thinkpad";

  # Filesystems
  boot.supportedFilesystems = [ "btrfs" ];

  # laptop optimisation
  nix.settings = {
    max-jobs = 2;
    cores = 2;
    auto-optimise-store = true;
  };

  boot.tmp.useTmpfs = false;

  # Automatic garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

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
        # Aktiviert Touchpad-Settings und die speziellen Keybinds
        hasTouchpad = true; 
      
        monitorConfig = ''
          output "eDP-1" {
              mode "1366x768"
              scale 0.8
          }
        '';
      };
    };
  };

  system.stateVersion = "26.05";
}
