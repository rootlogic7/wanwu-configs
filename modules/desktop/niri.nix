{ config, pkgs, ... }: {
  
  # ===========================================================================
  # 1. WINDOW MANAGER: NIRI
  # ===========================================================================
  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
  };

  # ===========================================================================
  # 2. TERMINAL, SHELL & BROWSER
  # ===========================================================================
  environment.systemPackages = with pkgs; [
    # Ghostty Terminal Emulator
    ghostty       
    
    # Nushell wird hier nur als Paket installiert, NICHT als System-Shell gesetzt!
    nushell
    
    # Webbrowser
    qutebrowser   
    
    # Niri-spezifische Abhängigkeiten
    xwayland-satellite 
    
    # Moderne Rust-basierte CLI Tools
    bat eza fd ripgrep zoxide 
  ];

  # ===========================================================================
  # 3. WAYLAND BASIS-EINSTELLUNGEN
  # ===========================================================================
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "ghostty";
  };
}
