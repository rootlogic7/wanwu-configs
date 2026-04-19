# modules/features/apps/neovim/default.nix
{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.features.apps.neovim;
in {
  # ===========================================================================
  # OPTIONEN
  # ===========================================================================
  options.features.apps.neovim = {
    enable = lib.mkEnableOption "Neovim IDE (via Home Manager)";
  };

  # ===========================================================================
  # CONFIGURATION
  # ===========================================================================
  config = lib.mkIf cfg.enable {
    
    # USER-EBENE: Neovim über Home Manager konfigurieren
    home-manager.users.${config.mainUser} = {
      
      programs.neovim = {
        enable = true;
        defaultEditor = true; # Setzt automatisch EDITOR="nvim"
        
        # 1. Deine LSPs und CLI-Tools (vorher lspsAndRuntimeDeps)
        extraPackages = with pkgs; [
          vtsls
          lua-language-server
          ripgrep
          fd
        ];

        # 2. Deine Plugins (vorher startupPlugins)
        plugins = with pkgs.vimPlugins; [
          nvim-lspconfig
          telescope-nvim
          catppuccin-nvim
        ];

        # 3. Deine Lua-Konfiguration direkt einlesen
        extraLuaConfig = builtins.readFile ./lua/init.lua;
      };

    };
  };
}

