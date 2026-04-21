# modules/features/cli/nushell/default.nix
{ config, pkgs, lib, ... }:

let
  cfg = config.features.cli.nushell;
in {
  # ===========================================================================
  # OPTIONEN (Der Schalter für dieses Feature)
  # ===========================================================================
  options.features.cli.nushell = {
    enable = lib.mkEnableOption "Nushell, Starship prompt and CLI tools";
  };

  # ===========================================================================
  # CONFIG (Wird nur ausgeführt, wenn enable = true ist)
  # ===========================================================================
  config = lib.mkIf cfg.enable {

    # 1. SYSTEM-EBENE (Pakete, die für alle User da sein sollen)
    environment.systemPackages = with pkgs; [
      bat
      eza
      fd
      ripgrep
    ];

    # 2. USER-EBENE (Home Manager Konfiguration für deinen Main-User)
    home-manager.users.${config.mainUser} = {
      
      # Zoxide (Smarter 'cd' Ersatz)
      programs.zoxide = {
        enable = true;
        enableNushellIntegration = true;
      };

      # Starship Prompt
      programs.starship = {
        enable = true;
        settings = {
          add_newline = false;
        };
      };

      # Nushell Konfiguration
      programs.nushell = {
        enable = true;
        shellAliases = {
          # System
          nrs = "sudo nixos-rebuild switch --flake /home/${config.mainUser}/wanwu-configs";
          nrt = "sudo nixos-rebuild test --flake /home/${config.mainUser}/wanwu-configs";
          nru = "nix flake update --flake /home/${config.mainUser}/wanwu-configs";
          ngc = "sudo nix-env --delete-generations old; sudo nix-collect-garbage -d";
          nopt = "nix-store --optimise";

          # Navigation
          ".." = "cd ..";
          "..." = "cd ../..";
          
          # Tools
          c = "clear";
          e = "exit";
          vim = "nvim";
          vi = "nvim";
          v = "nvim";
          
          # Git
          gs = "git status";
          ga = "git add .";
          gc = "git commit -m";
          gp = "git push";
          
          # Info
          bdf = "sudo btrfs filesystem df /";
          bat = "acpi -V";

          # Startet Aider mit einem Coding-Modell im aktuellen Verzeichnis
          askai = "aider --model ollama/deepseek-coder-v2:lite";
          # Einfaches Gespräch im Terminal ohne Datei-Kontext
          chat = "ollama run qwen2.5-coder:7b";
        };
      };
    };
  };
}
