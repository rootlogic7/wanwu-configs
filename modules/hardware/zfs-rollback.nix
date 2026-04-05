{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.zfs-rollback;
in {
  options.custom.hardware.zfs-rollback = {
    enable = lib.mkEnableOption "ZFS rollback on boot for Impermanence";
    pool = lib.mkOption {
      type = lib.types.str;
      default = "rpool"; 
      description = "Der Name des ZFS-Pools, der zurückgesetzt werden soll.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Benötigt systemd in der initrd (falls nicht ohnehin schon systemweit aktiv)
    boot.initrd.systemd.enable = true;

    boot.initrd.systemd.services.zfs-rollback = {
      description = "Rollback ZFS root and home datasets to a pristine state (blank)";
      wantedBy = [ "initrd.target" ];
      # Muss nach dem Importieren des Pools, aber VOR dem Mounten des Dateisystems laufen
      after = [ "zfs-import-${cfg.pool}.service" ];
      before = [ "sysroot.mount" ];
      path = with pkgs; [ zfs ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        echo "Rolling back ZFS datasets on ${cfg.pool}..."
        zfs rollback -r ${cfg.pool}/root@blank
        zfs rollback -r ${cfg.pool}/home@blank
        echo "Rollback complete."
      '';
    };
  };
}
