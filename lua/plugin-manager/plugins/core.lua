return {
  -- File manager
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function(_, opts)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("oil").setup(opts)
    end,
    opts = {
      delete_to_trash = true,
      trash_command = 'trash',
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { '<leader>pv', '<cmd>Oil<cr>', desc = 'Open current directory with Oil' },
    },
  },
  -- Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update { with_sync = true } end,
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'python' }
      },
    },
    config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      "MaximilianLloyd/adjacent.nvim",
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      local telescope = require 'telescope'

      telescope.load_extension 'fzf'
      telescope.load_extension 'adjacent'
      telescope.load_extension "undo"
    end,
    keys = function()
      return {
        { '<leader>b', function() require('telescope.builtin').buffers() end, desc = 'Open buffers with Telescope' },
        {
          '<leader>pfr',
          function() require('telescope.builtin').find_files() end,
          desc = 'Open root directory with Telescope'
        },
        {
          '<leader>ps',
          function() require('telescope.builtin').grep_string { search = vim.fn.input 'Grep > ' } end,
          desc = 'Search in root directory with Telescope',
        },
        {
          "<leader>pfa",
          "<cmd>Telescope adjacent<cr>",
          desc = 'Open adjacent files with Telescope',
          noremap = true,
          silent = false,
        },
        { "<leader>u", "<cmd>Telescope undo<cr>",                             desc = 'Open undotree with Telescope' },
      }
    end,
  },
}
