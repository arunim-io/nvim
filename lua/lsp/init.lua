local lsp_preset = require('config.utils').isNixOS and 'system-lsp' or 'recommended'
local lsp = require('lsp-zero').preset(lsp_preset)

lsp.on_attach(function(client, bufnr)
  require('lsp.keymaps').handle_keymaps(lsp, client, bufnr)
  lsp.buffer_autoformat()
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

require('lsp.language-servers').setup_lsps(lsp)
lsp.setup()

require 'lsp.language-servers'
require('lsp.language-servers').setup_flutter_tools(lsp)
require 'lsp.completions'
require 'lsp.null-ls'
