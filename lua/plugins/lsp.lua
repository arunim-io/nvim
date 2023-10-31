return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = false,
    init = function()
      -- Disable automatic setup
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = 'L3MON4D3/LuaSnip',
    config = function() require "lsp.cmp" end
  },
  -- LSP
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function() require 'lsp' end
  },
  -- Formatters
  {
    'stevearc/conform.nvim',
    event = "LspAttach",
    config = true,
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        ["_"] = { 'prettierd' },
        bash = { 'shfmt' },
        fish = { 'fish_indent' },
        nix = { 'nixpkgs_fmt' },
        python = { 'black', 'ruff_fix', 'ruff_format' },
        sh = { 'shfmt' },
      },
    },
    keys = {
      {
        "<leader>f",
        function() require("conform").format { async = true, lsp_fallback = true } end,
        mode = 'n',
        desc = "Format current buffer",
      },
    },
  },
  -- Linters
  {
    'mfussenegger/nvim-lint',
    event = "LspAttach",
    init = function()
      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
        callback = function() require("lint").try_lint() end,
      })
    end,
    config = function()
      require('lint').linters_by_ft = {
        bash = { 'shellcheck' },
        djangohtml = { 'djlint' },
        sh = { 'shellcheck' },
      }
    end,
  },
  -- lsp helper for neovim
  { "folke/neodev.nvim",    config = true,                                  ft = 'lua' },
  -- diagnostics helper
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "LspAttach",
    config = true,
    keys = function()
      local function set(map, cmd, desc) return { map, cmd, desc, silent = true, noremap = true } end

      return {
        set("<leader>d", "<cmd>TroubleToggle<cr>", 'Enable/disable Trouble'),
        set("<leader>dd", "<cmd>TroubleToggle document_diagnostics<cr>", 'Show diagnostics for current buffer'),
        set("<leader>dw", "<cmd>TroubleToggle workspace_diagnostics<cr>", "Show diagnostics for current workspace"),
      }
    end,
  },
  -- code action indicator
  {
    'kosayoda/nvim-lightbulb',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    event = "LspAttach",
    opts = { autocmd = { enabled = true } },
  },
  -- lsp loading indicator
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = true,
  },
  -- JSON Schema support
  { "b0o/schemastore.nvim", ft = { 'json', 'jsonc', 'toml', 'yaml', 'yml' } },
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap' },
    config = true,
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set('n', '<leader>ca', '<cmd>RustCodeAction<cr>', { buffer = bufnr })
        end,
      },
    },
  },
}
