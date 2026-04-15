{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.btrfs-rollback;
in {
  options.custom.hardware.btrfs-rollback = {
    enable = lib.mkEnableOption "Btrfs rollback on boot for Impermanence";
    
    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/mapper/cryptroot";
      description = "Das LUKS Device, auf dem sich Btrfs befindet.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd.enable = true;
    boot.initrd.systemd.services.btrfs-rollback = {
      description = "Rollback Btrfs root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-cryptsetup@cryptroot.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /btrfs_tmp
        mount -o subvol=/ ${cfg.device} /btrfs_tmp

        if [ -d "/btrfs_tmp/root" ]; then
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
  };
}
