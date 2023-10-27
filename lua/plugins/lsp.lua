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
    dependencies = { 'L3MON4D3/LuaSnip' },
    config = function() require "lsp.cmp" end
  },
  -- LSP
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function() require 'lsp.servers' end
  },
  -- Formatters
  {
    'stevearc/conform.nvim',
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
  {
    'mfussenegger/nvim-lint',
    event = 'BufReadPre',
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
}
