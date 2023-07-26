local M = {}

function M.lsp_zero_config()
  -- This is where you modify the settings for lsp-zero
  -- Note: autocompletion settings will not take effect
  require('lsp-zero.settings').preset {}
end

function M.cmp_config()
  -- Here is where you configure the autocompletion settings.
  -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
  -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

  require('lsp-zero.cmp').extend()

  -- And you can configure cmp even more, if you want to.
  local cmp = require 'cmp'
  local cmp_action = require('lsp-zero.cmp').action()

  cmp.setup {
    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    }
  }
end

function M.lsp_config()
  -- This is where all the LSP shenanigans will live

  local lsp = require 'lsp-zero'

  lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps { buffer = bufnr, omit = { '<F2>', '<F3>', '<F4>', 'gl' } }

    local maps = vim.lsp.buf
    local map = vim.keymap.set

    local function opts(desc) return { desc = desc, buffer = client.buf } end

    map("n", "<leader>f", maps.format, opts 'Format current file')
    map('n', '<leader>ca', maps.code_action, opts 'Open code action menu')
    map('n', '<leader>dl', vim.diagnostic.open_float, opts 'Show diagnostic for current line')
    map('n', '<leader>rn', maps.rename, opts 'Rename current word')
  end)

  -- (Optional) Configure lua language server for neovim
  require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

  lsp.setup()
end

return M
