{ pkgs, ... }: {
  # ===========================================================================
  # KERNEL (Bleeding Edge für Btrfs & Wayland)
  # ===========================================================================
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bioas firmware updates
  services.fwupd.enable = true;

  # Energie-Management (TLP ist der Standard für Laptops)
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };

  services.thermald.enable = true;
  services.upower.enable = true;

  networking.networkmanager.wifi.backend = "iwd";

  # ===========================================================================
  # BLUETOOTH
  # ===========================================================================
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Standardmäßig beim Hochfahren aktivieren
    settings = {
      General = {
        Experimental = true; # Zeigt z.B. den Akkustand deiner Kopfhörer an
      };
    };
  };
  
  # Blueman (GUI Manager) für einfaches Koppeln in Wayland/Niri
  services.blueman.enable = true;

  # Touchpad-Unterstützung (Libinput)
  services.libinput.enable = true;

  # Zusätzliche Pakete für Mobilität
  environment.systemPackages = with pkgs; [
    acpi        # Akku-Status im Terminal prüfen
    powertop    # Stromverbrauch-Analyse
    brightnessctl # Bildschirmhelligkeit via CLI
  ];
}
