local lsp = require('lsp-zero').preset "system-lsp"

lsp.on_attach(function(client, bufnr) require('lsp.keymaps').handle_keymaps(lsp,client, bufnr) end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

require 'lsp.completions'
