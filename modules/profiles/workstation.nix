{ pkgs, ... }: 
  # Der absolute Bleeding-Edge Kernel für maximale Nvidia/Wayland Performance
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Performance-Tweaks für Desktop-Betrieb
  powerManagement.cpuFreqGovernor = "performance";

  # Hier könnten später grafische Oberflächen oder 
  # spezifische Audio-Setups (Pipewire) landen.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
