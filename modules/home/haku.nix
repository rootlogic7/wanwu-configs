{ config, pkgs, ... }: 
let
  theme = import ./theme.nix;
in {
  imports = [
    ./niri/default.nix
    # ./nvim/default.nix  <-- später!
  ];

  # ===========================================================================
  # NUSHELL CONFIG
  # ===========================================================================
  programs.nushell = {
    enable = true;
    # Hier kannst du später Aliase und spezifische Nushell-Umgebungsvariablen setzen
  };

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
      
      background = theme.colors.bg;
      foreground = theme.colors.fg;
      cursor-color = theme.colors.cursor;
      
      palette = [
        "0=${theme.colors.black}"
        "1=${theme.colors.red}"
        "2=${theme.colors.green}"
        "3=${theme.colors.yellow}"
        "4=${theme.colors.blue}"
        "5=${theme.colors.magenta}"
        "6=${theme.colors.cyan}"
        "7=${theme.colors.white}"
        "8=${theme.colors.bright_black}"
        "9=${theme.colors.bright_red}"
        "10=${theme.colors.bright_green}"
        "11=${theme.colors.bright_yellow}"
        "12=${theme.colors.bright_blue}"
        "13=${theme.colors.bright_magenta}"
        "14=${theme.colors.bright_cyan}"
        "15=${theme.colors.bright_white}"
      ];
    };
  }; 

  # Wichtig für Home Manager: Die State Version muss gesetzt sein
  home.stateVersion = "26.05";
}
