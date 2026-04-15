{ inputs, config, pkgs, ... }: {
  # ===========================================================================
  # 0. LOGIN MANAGER (greetd + tuigreet)
  # ===========================================================================
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Startet tuigreet und führt nach erfolgreichem Login 'niri-session' aus
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Verhindert, dass Kernel- oder Systemd-Logs den schönen Login-Screen überlagern
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; 
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
  
  # ===========================================================================
  # XDG PORTALS (Verhindert den 120-Sekunden App-Start-Bug)
  # ===========================================================================
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      niri = {
        default = [ "gnome" "gtk" ];
      };
    };
  };

  # Wichtig für Qt-Apps (wie Quickshell) unter Wayland
  environment.variables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # ===========================================================================
  # 1. WINDOW MANAGER: NIRI
  # ===========================================================================
  programs.niri.enable = true;

  # ===========================================================================
  # 2. TERMINAL, SHELL & BROWSER
  # ===========================================================================
  environment.systemPackages = with pkgs; [
    # Ghostty Terminal Emulator
    ghostty       
    
    # App-Launcher
    fuzzel

    # Webbrowser
    qutebrowser  

    # Niri-spezifische Abhängigkeiten
    xwayland-satellite 

    inputs.niri-quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code # Installiert FiraCode mit allen Nerd-Font Icons
  ];

  # ===========================================================================
  # 3. WAYLAND BASIS-EINSTELLUNGEN
  # ===========================================================================
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "ghostty";
  };
}
