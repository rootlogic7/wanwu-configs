{ config, pkgs, ... }: {
  
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  
  # Wir nutzen den Host-SSH-Key zum Entschlüsseln. 
  # Da / flüchtig ist, weisen wir auf den persistenten Pfad!
  sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

  # Das Passwort für Zhenren deklarieren
  sops.secrets."users/${config.mainUser}/password" = {
    neededForUsers = true;
  };
}
