local lsp = require 'lsp-zero'

lsp.extend_lspconfig()

require('lsp.keymaps').setup_keymaps(lsp)

local lspconfig = require 'lspconfig'

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
