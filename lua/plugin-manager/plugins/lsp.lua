return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    config = function() require('config.lsp').lsp_zero_config() end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = { 'L3MON4D3/LuaSnip' },
    config = function() require('config.lsp').cmp_config() end,
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function() require('config.lsp').lsp_config() end,
  }
}
