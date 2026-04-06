{
  disko.devices = {
    disk = {
      # -----------------------------------------------------------------------
      # 1. SSD: SYSTEM RAKETE (NVMe 0) - ZFS
      # -----------------------------------------------------------------------
      system = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS1N529304A";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                # Bei der Installation diese Datei vorher anlegen: echo -n "passwort" > /tmp/secret.key
                passwordFile = "/tmp/secret.key";
                settings.allowDiscards = true; # Wichtig für NVMe TRIM
                content = {
                  type = "zfs";
                  pool = "rpool";
                };
              };
            };
          };
        };
      };

      # -----------------------------------------------------------------------
      # 2. SSD: PERFORMANCE & GAMES (NVMe 1) - BTRFS
      # -----------------------------------------------------------------------
      games = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS1N533652F";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptgames";
                passwordFile = "/tmp/secret.key";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Erzwingt Formatierung
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/storage/games";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };

      # -----------------------------------------------------------------------
      # 3. HDD: DATENGRAB / ARCHIV (4TB WD) - ZFS
      # -----------------------------------------------------------------------
      media = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD40_DEINE_4TB_HDD_ID_HIER";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptmedia";
                passwordFile = "/tmp/secret.key";
                content = {
                  type = "zfs";
                  pool = "mediapool";
                };
              };
            };
          };
        };
      };

      # -----------------------------------------------------------------------
      # 4. HDD: LOKALES BACKUP VAULT (2TB TOSHIBA) - BTRFS
      # -----------------------------------------------------------------------
      backup = {
        type = "disk";
        device = "/dev/disk/by-id/ata-TOSHIBA_DT01ACA200_94JKP2VHS";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptbackup";
                passwordFile = "/tmp/secret.key";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/storage/backup";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };

    # -----------------------------------------------------------------------
    # ZFS POOLS & DATASETS KONFIGURATION
    # -----------------------------------------------------------------------
    zpool = {
      rpool = {
        type = "zpool";
        options = { ashift = "12"; autotrim = "on"; };
        rootFsOptions = { acltype = "posixacl"; xattr = "sa"; compression = "zstd"; mountpoint = "none"; };
        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            # Erstellt den Rollback-Snapshot für Erase Your Darlings direkt bei der Installation
            postCreateHook = "zfs snapshot rpool/root@blank";
          };
          "nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          "persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };
          "home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
            postCreateHook = "zfs snapshot rpool/home@blank";
          };
        };
      };

      mediapool = {
        type = "zpool";
        options = { ashift = "12"; autotrim = "on"; };
        rootFsOptions = { acltype = "posixacl"; xattr = "sa"; compression = "zstd"; mountpoint = "none"; };
        datasets = {
          "media" = {
            type = "zfs_fs";
            mountpoint = "/storage/media";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
