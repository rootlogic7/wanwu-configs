{ config, pkgs, ... }: {
  
  # ===========================================================================
  # GHOSTTY CONFIG
  # ===========================================================================
  xdg.configFile."ghostty/config".text = ''
    command = nu
  '';

  # ===========================================================================
  # NIRI CONFIG (Minimales Überlebens-Setup)
  # ===========================================================================
  xdg.configFile."niri/config.kdl".text = ''
    // Starte Ghostty automatisch
    spawn-at-startup "ghostty"

    binds {
        // Programme starten (Super = Mod)
        Mod+Return { spawn "ghostty"; }
        Mod+B { spawn "qutebrowser"; }

        // Fenster-Management
        Mod+Shift+C { close-window; }
        Mod+Shift+E { quit; } // Beendet Niri

        // Navigation (Horizontal)
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
    }
  '';

  # Wichtig für Home Manager: Die State Version muss gesetzt sein
  home.stateVersion = "26.05";
}
