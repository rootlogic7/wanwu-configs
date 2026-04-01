{ pkgs, ... }: {
  # Energie-Management (TLP ist der Standard für Laptops)
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };

  # Touchpad-Unterstützung (Libinput)
  services.libinput.enable = true;

  # Zusätzliche Pakete für Mobilität
  environment.systemPackages = with pkgs; [
    acpi        # Akku-Status im Terminal prüfen
    powertop    # Stromverbrauch-Analyse
    brightnessctl # Bildschirmhelligkeit via CLI
  ];
}
