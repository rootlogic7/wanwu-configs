{ config, pkgs, ... }: {
  # ===========================================================================
  # NETZWERK BASIS
  # ===========================================================================
  networking.networkmanager.enable = true;

  # Hier ist Platz für zukünftige Erweiterungen wie:
  # networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # services.tailscale.enable = true;
}
