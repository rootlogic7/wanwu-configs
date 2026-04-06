{ config, pkgs, ... }: 
let
  theme = import ../theme.nix;
in {
  # ===========================================================================
  # NIRI CONFIG (Home Manager)
  # ===========================================================================
  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
   	    xkb {
	        layout "de"
	    }
	}
        //warp-mouse-to-focus mode="center-xy-always"
	focus-follows-mouse
	//workspace-auto-back-and-forth
    }
    output "eDP-1" {
        mode "1366x768"
        scale 0.8
        position x=0 y=0
        //variable-refresh-rate
        focus-at-startup
        backdrop-color "${theme.colors.bg}"

        hot-corners {
            //top-left
            top-right
            //bottom-left
            //bottom-right
        }
    }

    binds {
        // Programme starten
        Mod+Return { spawn "ghostty"; }
        Mod+Q { spawn "ghostty"; }
        Mod+Space { spawn "fuzzel"; }

        // Fenster-Management
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+T { toggle-column-tabbed-display; }
        Mod+Shift+C { close-window; }
        Mod+Shift+E { quit; }

        // Navigation (Horizontal)
        Mod+Left { focus-column-left; }
        Mod+H { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+L { focus-column-right; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }

        // Navigation (Vertical)
        Mod+Down { focus-workspace-down; }
        Mod+J { focus-workspace-down; }
        Mod+Up { focus-workspace-up; }
        Mod+K { focus-workspace-up; }

        Mod+TouchpadScrollDown cooldown-ms=250 { focus-workspace-down; }
        Mod+TouchpadScrollUp cooldown-ms=250 { focus-workspace-up; }

        // Audio Control
        //Mod+Shift+TouchpadScrollDown { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; }
        //Mod+Shift+TouchpadScrollUp   { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; }
        // --- ThinkPad Audio Tasten (F1, F2, F3) ---
        XF86AudioMute        { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        // Das "-l 1.0" bei RaiseVolume ist wichtig, damit du nicht versehentlich über 100% gehst und die Lautsprecher übersteuerst!
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
    }

    layout {
        gaps 16

        center-focused-column "on-overflow"

        empty-workspace-above-first

        default-column-display "normal"
        tab-indicator {
            width 8
            gap 8
            length total-proportion=1.0
            position "top"
            corner-radius 4
            place-within-column
            hide-when-single-tab
            active-gradient from="${theme.colors.accent_secondary}" to="${theme.colors.accent_tertiary}" angle=45 relative-to="workspace-view"
        }
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            fixed 1280
        }
        default-column-width {}

        preset-window-heights {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            fixed 720
        }

        border {
            width 2

            active-gradient from="${theme.colors.accent_primary}" to="${theme.colors.accent_tertiary}" angle=45 relative-to="workspace-view"
            inactive-gradient from="${theme.colors.accent_secondary}" to="${theme.colors.inactive_border}" angle=45 relative-to="workspace-view"
            urgent-color "${theme.colors.bright_blue}"
        }
        focus-ring {
            width 2
            
            active-color "${theme.colors.accent_primary}"
            inactive-color "${theme.colors.inactive_border}"
            urgent-color "${theme.colors.bright_blue}"
        }
        
        shadow {
            on
        }

        insert-hint {
            on
            gradient from="${theme.colors.accent_tertiary}" to="${theme.colors.inactive_border}" angle=45 relative-to="workspace-view"
        }

        struts {
            left 8
            right 8
            top 32
            bottom 16
        }
        background-color "${theme.colors.bg}"
    }
    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png"
    cursor {
        hide-when-typing
        hide-after-inactive-ms 800
    }

    overview {
        zoom 0.45
        backdrop-color "${theme.colors.inactive_border}"
        workspace-shadow {
            on
        }
    }
  '';
}
