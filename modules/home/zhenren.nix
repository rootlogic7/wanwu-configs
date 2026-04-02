{ config, pkgs, ... }: 
let
  # Hier laden wir deine neue Theme-Datei
  theme = import ./theme.nix;
in {
  
  # ===========================================================================
  # GHOSTTY CONFIG
  # ===========================================================================
  xdg.configFile."ghostty/config".text = ''
    command = nu
    
    //Schriften aus dem Theme laden
    font-family = "${theme.fonts.terminal}"
    font-size = ${theme.fonts.size}
    window-padding-x = 10
    window-padding-y = 10
    
    //Farben aus dem Theme laden
    background = ${theme.colors.bg}
    foreground = ${theme.colors.fg}
    cursor-color = ${theme.colors.cursor}
    
    palette = 0=${theme.colors.color0}
    palette = 1=${theme.colors.color1}
    palette = 2=${theme.colors.color2}
  '';

  # ===========================================================================
  # NIRI CONFIG
  # ===========================================================================
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "ghostty"

    layout {
        gaps 12
        border {
            width 2
            //Farben für die Rahmen dynamisch aus dem Theme laden
            active-color "${theme.colors.border_active}"
            inactive-color "${theme.colors.border_inactive}"
        }
    }

    binds {
        // Programme starten
        Mod+Return {
            spawn "ghostty"
        }
        Mod+B {
            spawn "qutebrowser"
        }

        // Fenster-Management
        Mod+Shift+C {
            close-window
        }
        Mod+Shift+E {
            quit
        }

        // Navigation (Horizontal)
        Mod+Left {
            focus-column-left
        }
        Mod+Right {
            focus-column-right
        }
        Mod+Shift+Left {
            move-column-left
        }
        Mod+Shift+Right {
            move-column-right
        }
    }
  '';

  # Wichtig für Home Manager: Die State Version muss gesetzt sein
  home.stateVersion = "26.05";
}
