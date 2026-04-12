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
  
  # 1. TLP Konflikte zwingend vermeiden
  services.power-profiles-daemon.enable = false;

  # 2. Intel Thinkpad Throttling Fix (sehr wichtig für ältere Modelle!)
  # Verhindert, dass die CPU unter Last viel zu früh heruntertaktet (PROCHOT issue)
  services.throttled.enable = true;

  # 3. Hardware Video Acceleration (Schont den Akku enorm)
  hardware.graphics = { # Hinweis: hardware.opengl heißt in unstable nun hardware.graphics
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # Für Broadwell (5th Gen) und neuer
      # intel-vaapi-driver # Falls es Haswell (4th Gen) oder älter ist
    ];
  };

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
