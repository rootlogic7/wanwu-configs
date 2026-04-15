# modules/features/apps/ghostty/default.nix
{ config, pkgs, lib, ... }:

let
  cfg = config.features.apps.ghostty;
  # Später können wir das Theme auch globaler machen
  theme = import ../../../core/theme.nix; 
in {
  options.features.apps.ghostty = {
    enable = lib.mkEnableOption "Ghostty Terminal Emulator";
  };

  config = lib.mkIf cfg.enable {
    # System-Paket (Kannst du dann aus der Niri-Config löschen!)
    environment.systemPackages = [ pkgs.ghostty ];

    home-manager.users.${config.mainUser} = {
      programs.ghostty = {
        enable = true;
        settings = {
          command = "nu";
          font-family = theme.fonts.terminal;
          font-size = theme.fonts.size;
          window-padding-x = 10;
          window-padding-y = 10;
          config-file = "?~/.config/niri-quickshell/ghostty/colors";
        };
      };
    };
  };
}
