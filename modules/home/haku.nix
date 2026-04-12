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
    shellAliases = {
      # System rebuilden (Thinkpad)
      nrs = "sudo nixos-rebuild switch --flake ~/wanwu-configs#thinkpad";
      
      # System rebuilden und gleich testen (ohne es permanent in den Bootloader zu schreiben)
      nrt = "sudo nixos-rebuild test --flake ~/wanwu-configs#thinkpad";
      
      # Flake Inputs updaten (z.B. neue Nixpkgs Versionen ziehen)
      nru = "nix flake update --flake ~/wanwu-configs";
      
      # Alten Müll aufräumen (Garbage Collection manuell anstoßen)
      ngc = "sudo nix-env --delete-generations old; sudo nix-collect-garbage -d";
      
      # Nix-Store optimieren (Hardlinks erzwingen)
      nopt = "nix-store --optimise";

      ".." = "cd ..";
      "..." = "cd ../..";
      
      # Standard-Tools
      c = "clear";
      e = "exit";
      
      # Neovim als Standard-Editor forcieren (sobald du es aktiviert hast)
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
      
      # Git Shortcuts für dein wanwu-configs Repo
      gs = "git status";
      ga = "git add .";
      gc = "git commit -m";
      gp = "git push";

      # Zeigt den Btrfs-Speicherplatz korrekt an (besser als normales df)
      bdf = "sudo btrfs filesystem df /";
      
      # Akku-Status schnell prüfen (nutzt das 'acpi' Paket aus deinem laptop.nix Profil)
      bat = "acpi -V";
    };
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
      
      config-file = "?~/.config/niri-quickshell/ghostty/colors";
    };
  };
 
  # Starship ist blitzschnell und integriert sich nahtlos in Nushell
  programs.starship = {
    enable = true;
    # enableNushellIntegration = true; # (Wird meist automatisch von HM gesetzt)
    settings = {
      add_newline = false;
      # ... hier kannst du später das Theme an deine Quickshell anpassen
    };
  };

  # Zoxide als smarter 'cd' Ersatz (funktioniert super mit Nushell)
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Wichtig für Home Manager: Die State Version muss gesetzt sein
  home.stateVersion = "26.05";
}
