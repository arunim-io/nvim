local loadMason = not require('config.utils').isNixOS

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
      { 'williamboman/mason.nvim',           enabled = loadMason },
      { 'williamboman/mason-lspconfig.nvim', enabled = loadMason },
    },
  },
  -- Helper plugin to show when code actions are available
  {
    'kosayoda/nvim-lightbulb',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    opts = { autocmd = { enabled = true } },
  },
  -- LSP diagnostics viewer
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
    keys = function()
      local function set(map, cmd, desc) return { map, cmd, desc, silent = true, noremap = true } end

      return {
        set("<leader>d", "<cmd>TroubleToggle<cr>", 'Enable/disable Trouble'),
        set("<leader>dd", "<cmd>TroubleToggle document_diagnostics<cr>", 'Show diagnostics for current buffer'),
        set("<leader>dw", "<cmd>TroubleToggle workspace_diagnostics<cr>", "Show diagnostics for current workspace"),
        set("<leader>qf", "<cmd>TroubleToggle quickfix<cr>", 'Show quick fix list'),
        set("<leader>dl", "<cmd>TroubleToggle loclist<cr>"),
      }
    end,
  },
  -- Formatters & linters
  { "jose-elias-alvarez/null-ls.nvim", dependencies = 'nvim-lua/plenary.nvim' },
  -- Helper for highlighting variables
  {
    'tzachar/local-highlight.nvim',
    config = true,
    init = function()
      vim.api.nvim_create_autocmd('BufRead', {
        pattern = { '*.*' },
        callback = function(data) require('local-highlight').attach(data.buf) end,
      })
    end,
  },
  -- Useful when configuring neovim
  { "folke/neodev.nvim",               config = true },
  -- JSON Schema support
  { "b0o/schemastore.nvim",            ft = { 'json', 'jsonc', 'toml', 'yaml', 'yml' } },
  -- Rust support
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap' },
  },
  -- JavaScript & TypeScript support
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", 'jose-elias-alvarez/typescript.nvim' },
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    config = true,
    opts = {
      complete_function_calls = true,
    },
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    ft = 'dart',
    dependencies = { 'nvim-lua/plenary.nvim', 'stevearc/dressing.nvim' },
  },
}
