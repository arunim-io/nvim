local lsp = require 'lsp-zero'

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps { buffer = bufnr, omit = { '<F2>', '<F3>', '<F4>', 'gl' } }

  local maps = vim.lsp.buf
  local map = vim.keymap.set

  local function opts(desc) return { desc = desc, buffer = client.buf } end

  map("n", "<leader>f", maps.format, opts 'Format current file')
  map('n', '<leader>ca', maps.code_action, opts 'Open code action menu')
  map('n', '<leader>rn', maps.rename, opts 'Rename current word')
end)
