return {
  -- LSP provider
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'L3MON4D3/LuaSnip',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },
  },
  -- Useful when configuring neovim
  { "folke/neodev.nvim",    config = true },
  -- JSON Schema support
  { "b0o/schemastore.nvim", ft = { 'json', 'jsonc', 'toml', 'yaml', 'yml' } },
  -- Helper plugin to show when code actions are available
  {
    'kosayoda/nvim-lightbulb',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    opts = { autocmd = { enabled = true } },
  },
  -- Formatters & linters
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = 'nvim-lua/plenary.nvim',
  },
}
