{ pkgs, ... }: {
  # ===========================================================================
  # KERNEL (Bleeding Edge für Nvidia Explicit Sync & Gaming)
  # ===========================================================================
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Performance-Tweaks für Desktop-Betrieb
  powerManagement.cpuFreqGovernor = "performance";

}
