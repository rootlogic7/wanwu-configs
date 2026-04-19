{ config, pkgs, lib, ... }: {
  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      { directory = "/var/lib/private"; mode = "0700"; }
    ];
    
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    
    users.${config.mainUser} = {
      directories = [
        "wanwu-configs"
        "Dev"
        "Downloads"
        "Documents"
        "Pictures"
        ".ssh"
        ".local/share/keyrings"
        ".local/share/direnv"
        ".local/share/zoxide"
        ".config/niri-quickshell"
        ".config/qutebrowser"
        ".local/share/qutebrowser"
      ];
      files = [
        ".config/nushell/history.txt"
      ];
    };
  };
}
