# modules/features/apps/neovim/default.nix
{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.features.apps.neovim;
  
  # Wir importieren den NixCats Builder
  nixCatsBuilder = inputs.nixCats.utils.standardPluginOverlay;
  
  # NixCats Definition
  myNixCats = inputs.nixCats.packages.${pkgs.system}.nixCatsBuilder {
    luaPath = "${./lua}";
    
    lspsAndRuntimeDeps = {
      default = with pkgs; [
        vtsls
        lua-language-server
        ripgrep
        fd
      ];
    };

    startupPlugins = {
      default = with pkgs.vimPlugins; [
        nvim-lspconfig
        telescope-nvim
        catppuccin-nvim
      ];
    };
  };
in {
  # ===========================================================================
  # OPTIONEN
  # ===========================================================================
  options.features.apps.neovim = {
    enable = lib.mkEnableOption "Neovim IDE configured via NixCats";
  };

  # ===========================================================================
  # CONFIGURATION
  # ===========================================================================
  config = lib.mkIf cfg.enable {
    
    # SYSTEM-EBENE: Wir könnten hier systemweite Dinge definieren, falls nötig.
    # Da Neovim meist ein reines User-Tool ist, bleibt das oft leer.

    # USER-EBENE: Home Manager Konfiguration
    home-manager.users.${config.mainUser} = {
      home.packages = [ myNixCats ];
      
      home.sessionVariables = {
        EDITOR = "nvim";
      };
    };
  };
}

