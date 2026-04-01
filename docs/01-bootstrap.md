# 01 - System Bootstrap (Neuinstallation)

   Dieses Dokument beschreibt den exakten Ablauf, um den Host `xun` von Grund auf neu auf einer leeren Maschine
   (oder nach einem totalen Systemcrash) zu installieren.

   **⚠️ WARNUNG: Dieser Prozess formatiert alle in `disko.nix` angegebenen Festplatten unwiderruflich!**


 ## 1. Vorbereitung

   1. NixOS vom USB-Stick booten (Graphical oder Minimal ISO).

   2. Internetverbindung herstellen (LAN ist out-of-the-box aktiv, für WLAN `nmtui` im Terminal nutzen).

   3. Root-Rechte erlangen:
   ```bash
    sudo su
   ```

   4. Tastaturlayout anpassen:
   ```bash
    loadkeys de-latin1
   ```


 ## 2. Das Repository vorbereiten

   Da das Repository öffentlich (public) ist, können wir es auf dem Live-Stick ganz ohne Authentifizierung klonen.

   1. Wechsle in das temporäre Verzeichnis:
   ```bash
    cd /tmp
   ```

   2. Klone das Repository:
   ```bash
    git clone [https://github.com/rootlogic7/wanwu-configs.git](https://github.com/rootlogic7/wanwu-configs.git)
   ```

   3. Betritt das Verzeichnis:
   ```bash
    cd wanwu-configs
   ```


 ## 3. Hardware-IDs ermitteln & eintragen

   Da sich /dev/sda oder /dev/nvme0n1 bei jedem Booten ändern können, nutzen wir persistente IDs.

   1. Finde die exakten IDs deiner Festplatten heraus:
   ```bash
    ls -l /dev/disk/by-id/
   ```

   (Ignoriere Einträge, die auf -part1, -part2 etc. oder wwn-... enden).

   2. Öffne die disko.nix und ersetze die Platzhalter durch deine echten IDs:
   ```bash
    nano hosts/xun/disko.nix
   ```

 ## 4. Hardware-Konfiguration generieren

   1. Lass NixOS erkennen, welche Kernel-Module für CPU und Mainboard benötigt werden:
   ```bash
    nixos-generate-config --show-hardware-config > hosts/xun/hardware-configuration.nix
   ```

   Hinweis: Da wir disko nutzen, ignoriert NixOS später automatisch eventuelle fileSystems Einträge
   in dieser Datei, wir müssen sie also nicht händisch löschen.
 

## 5. Festplatten formatieren & mounten (DISKO)

   1. Lege das temporäre LUKS-Passwort für die Installation fest (dies wird für alle 4 Platten genutzt):
   ```bash
    echo -n "DeinStrengGeheimesPasswort" > /tmp/secret.key
   ```

   2. Starte die Partitionierung:
   ```bash
    nix run github:nix-community/disko -- --mode disko ./hosts/xun/disko.nix
   ```

   Disko formatiert nun die Laufwerke, richtet ZFS/Btrfs ein und mountet alles automatisch nach /mnt.


 ## 5.5 SSH-Keys und SOPS-Secrets vorbereiten (Chicken-and-Egg-Problem)

   Da das System sein Passwort aus `secrets.yaml` liest, aber den SSH-Key zum Entschlüsseln braucht,
   müssen wir den Schlüssel jetzt manuell auf der frisch gemounteten Partition erstellen.

   1. Erstelle das persistente Verzeichnis für den SSH-Schlüssel:
   ```bash
    mkdir -p /mnt/persist/etc/ssh
   ```

   2. Generiere einen neuen Ed25519 SSH-Hostschlüssel (ohne Passwort):
   ```bash
    ssh-keygen -t ed25519 -N "" -C "xun" -f /mnt/persist/etc/ssh/ssh_host_ed25519_key
   ```

   3. Leite den öffentlichen age-Schlüssel für SOPS aus diesem SSH-Key ab:
   ```bash
    nix run nixpkgs#ssh-to-age -- -i /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub
   ```
    
  => Kopiere dir den Output (beginnt mit age1...) und trage ihn in die .sops.yaml im Repo ein.

   4. Generiere einen Hash für dein User-Passwort:
   ```bash
   nix run nixpkgs#mkpasswd -- -m sha-512
   ```

   6. Speichere das Passwort mit SOPS (mkdir -p secrets):
   ```bash
    EDITOR=nano nix run nixpkgs#sops -- secrets/secrets.yaml
   ```

   6. Inhalt der yaml:
   ```yaml
    users:
      zhenren:
        password: "DEIN_GENERIERTER_SHA512_HASH_HIER"
   ```


## 6. Der wichtigste Schritt: Git Add! (Flake-Falle)

   - Nix Flakes ignorieren alle Dateien, die Git nicht kennt! Bevor wir installieren, müssen wir Git sagen,
   dass es die neuen Dateien (vor allem die gerade generierte hardware-configuration.nix) gibt:
   ```bash
    git add .
   ```

   (Ein Commit ist nicht zwingend nötig, aber die Dateien müssen in der Staging-Area sein).


## 7. Die Installation

   - Installiere das System auf die frisch gemounteten Festplatten unter /mnt:
   ```bash
    nixos-install --flake .#xun
   ```

   Du wirst während der Installation nach einem Root-Passwort gefragt. Das kannst du leer lassen
   oder ein temporäres setzen (wir verwalten Nutzer später deklarativ).


## 8. Abschluss

   - Da /tmp beim Reboot gelöscht wird, müssen wir das Repo in den persistenten Home-Ordner verschieben,
   damit du nach dem Start direkt weiterarbeiten kannst:
   ```bash
    mkdir -p /mnt/persist/home/zhenren
    cp -a /tmp/wanwu-configs /mnt/persist/home/zhenren/
    nixos-enter --root /mnt -c "chown -R zhenren:users /persist/home/zhenren/wanwu-configs"
   ```

   - Wenn die Installation fehlerfrei durchgelaufen ist:
   ```bash
    reboot
   ```

   Zieh den USB-Stick ab. Das System sollte nun in den systemd-boot Bootloader starten und
   dich nach dem LUKS-Passwort fragen.


## 9. Nach dem ersten Boot: Ruhezustand (Hibernation) aktivieren

   Da `Btrfs` das Swapfile dynamisch anlegt, muss dem System nach der Erstinstallation mitgeteilt werden,
   wo genau auf der Festplatte sich dieses befindet, damit es beim Zuklappen des Laptops den RAM-Inhalt
   dorthin schreiben kann.

   1. Logge dich mit dem temporären Passwort in dein neues System ein.
    
   2. Finde den `resume offset` des Swapfiles heraus:
   ```bash
    sudo btrfs inspect-internal map-swapfile /swap/swapfile
   ```

   3. Das Terminal gibt dir eine Zahl aus (z.B. 5342938). Kopiere diese Zahl.

   4. Öffne deine Host-Konfiguration:
   ```bash
    nano ~/wanwu-configs/hosts/xun/default.nix
   ```

   5. Suche den Block für boot.kernelParams und trage die Zahl dort ein
   (und entferne das # am Anfang der Zeile, falls auskommentiert):
   ```nix
    boot.kernelParams = [ "resume_offset=DEINE_ZAHL_HIER" ];
   ```
   
   6. Wende die Änderung an, um den Ruhezustand dauerhaft zu aktivieren:
   ```bash
    sudo nixos-rebuild switch --flake ~/wanwu-configs/#xun
   ```
