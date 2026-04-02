{ config, pkgs, inputs, ... }:
let
  # Wir importieren den NixCats Builder
  nixCatsBuilder = inputs.nixCats.utils.standardPluginOverlay;
  
  # Hier definieren wir, welche LSPs, Plugins und Tools Nix für uns herunterladen soll
  myNixCats = inputs.nixCats.packages.${pkgs.system}.nixCatsBuilder {
    # Der Pfad zu deiner reinen Lua-Konfiguration (die wir gleich erstellen)
    luaPath = "${./lua}";
    
    # System-Abhängigkeiten und Language Server, die Nix bereitstellen soll
    lspsAndRuntimeDeps = {
      default = with pkgs; [
        vtsls                  # Der hochoptimierte TypeScript LSP
        lua-language-server    # Für die Neovim-Konfiguration selbst
        ripgrep                # Für schnelle Suchen (Telescope)
        fd
      ];
    };

    # Neovim Plugins, die Nix für uns installieren soll
    startupPlugins = {
      default = with pkgs.vimPlugins; [
        nvim-lspconfig         # Basis-LSP-Konfiguration
        telescope-nvim         # Fuzzy Finder
        catppuccin-nvim        # Beispiel-Theme (kannst du später anpassen)
      ];
    };
  };
in
{
  # Wir installieren den generierten NixCats-Neovim-Build in dein User-Profil
  home.packages = [
    myNixCats
  ];

  # Damit du Neovim ganz normal mit 'nvim' im Terminal starten kannst
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
