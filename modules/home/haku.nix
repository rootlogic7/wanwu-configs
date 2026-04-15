{ config, pkgs, ... }: 
let
  theme = import ./theme.nix;
in {
  # ===========================================================================
  # GHOSTTY CONFIG
  # ===========================================================================
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
 
  # Wichtig für Home Manager: Die State Version muss gesetzt sein
  home.stateVersion = "26.05";
}
