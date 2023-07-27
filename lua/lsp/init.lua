local lsp = require('lsp-zero').preset "system-lsp"

lsp.on_attach(function(client, bufnr)
  require('lsp.keymaps').handle_keymaps(lsp, client, bufnr)
  lsp.buffer_autoformat()
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

require 'lsp.completions'
require 'lsp.language-servers'
require 'lsp.null-ls'
