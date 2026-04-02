-- modules/home/nvim/lua/init.lua

-- Leader-Taste setzen (z.B. Space)
vim.g.mapleader = " "

-- Theme laden
vim.cmd.colorscheme("catppuccin")

-- LSP Konfiguration laden
local lspconfig = require('lspconfig')

-- 1. Lua LSP konfigurieren
lspconfig.lua_ls.setup {}

-- 2. Den neuen vtsls (TypeScript) konfigurieren
lspconfig.vtsls.setup {
  settings = {
    vtsls = {
      -- Aktiviert serverseitiges Fuzzy-Matching, um Neovim extrem zu entlasten
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      tsserver = { 
        maxTsServerMemory = 8192 
      },
    },
  }
}

-- Ein simples Keybinding zum Testen
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Fehler anzeigen" })
