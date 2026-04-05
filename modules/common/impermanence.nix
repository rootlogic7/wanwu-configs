{ config, pkgs, lib, ... }: {
  
  # Zwingend nötig, damit /persist beim Booten vor dem Rest gemountet wird
  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
    ];
    
    files = [
      "/etc/machine-id"
      # "/etc/ssh/ssh_host_ed25519_key" # Später entkommentieren, wenn SSH eingerichtet ist
    ];
    
    users.zhenren = {
      directories = [
        "wanwu-configs"  # Dein neues Repo muss überleben!
        "Dev"
        "Downloads"
        "Documents"
        "Pictures"
        ".ssh"
        ".local/share/keyrings"
        ".local/share/direnv"
        ".local/share/zoxide"
        # Browser und andere Configs können hier später noch rein
        ".config/qutebrowser"
        ".local/share/qutebrowser"
      ];
      files = [
        ".config/nushell/history.txt"
      ];
    };
  };
}
