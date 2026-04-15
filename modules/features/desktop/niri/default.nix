# modules/features/desktop/niri/default.nix
{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.features.desktop.niri;
in {
  # ===========================================================================
  # OPTIONEN
  # ===========================================================================
  options.features.desktop.niri = {
    enable = lib.mkEnableOption "Niri Wayland Compositor";
    
    hasTouchpad = lib.mkEnableOption "Touchpad-spezifische Konfigurationen und Keybinds";
    
    monitorConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Host-spezifischer KDL-String für die Monitor-Outputs";
    };
  };

  # ===========================================================================
  # CONFIGURATION
  # ===========================================================================
  config = lib.mkIf cfg.enable {

    # -------------------------------------------------------------------------
    # A. SYSTEM-EBENE (Root-Rechte, ehemals in modules/desktop/niri.nix)
    # -------------------------------------------------------------------------
    programs.niri.enable = true;

    # Login Manager (greetd + tuigreet)
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "greeter";
        };
      };
    };
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; 
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    # XDG Portals & Environment
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-gnome ];
      config.common.default = [ "gtk" ];
      config.niri.default = [ "gnome" "gtk" ];
    };

    environment.variables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      TERMINAL = "ghostty";
    };

    fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

    environment.systemPackages = with pkgs; [       
      fuzzel
      qutebrowser  
      xwayland-satellite 
      inputs.niri-quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # -------------------------------------------------------------------------
    # B. USER-EBENE (Home Manager, ehemals in modules/home/niri/default.nix)
    # -------------------------------------------------------------------------
    home-manager.users.${config.mainUser} = {
      xdg.configFile."niri/config.kdl".text = ''
        // ==========================================
        // HOST-SPEZIFISCHE MONITORE
        // ==========================================
        ${cfg.monitorConfig}

        // ==========================================
        // INPUT & TOUCHPAD
        // ==========================================
        input {
            keyboard {
              xkb { layout "de"; }
            }

            ${lib.optionalString cfg.hasTouchpad ''
            touchpad {
                tap
                natural-scroll
            }
            ''}
            warp-mouse-to-focus mode="center-xy-always"
            focus-follows-mouse
        }
        
        spawn-at-startup "bash" "-c" "sleep 2; exec niri-quickshell"
        
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

            ${lib.optionalString cfg.hasTouchpad ''
            Mod+TouchpadScrollDown cooldown-ms=250 { focus-workspace-down; }
            Mod+TouchpadScrollUp cooldown-ms=250 { focus-workspace-up; }
            ''}

            // --- ThinkPad Audio Tasten ---
            XF86AudioMute        { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
            XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
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

            border { width 2; }
            focus-ring { width 2; }
            shadow { on; }
            insert-hint { on; }

            struts {
                left 5
                right 5
                top 5
                bottom 5
            }
        }

        prefer-no-csd
        screenshot-path "~/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png"
        cursor {
            hide-when-typing
            hide-after-inactive-ms 800
        }

        overview {
            zoom 0.45
            workspace-shadow { on; }
        }
        include "/home/${config.mainUser}/.config/niri-quickshell/niri/colors.kdl"
      '';
    };
  };
}
