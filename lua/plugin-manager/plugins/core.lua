return {
  -- File manager
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      delete_to_trash = true,
      trash_command = 'trash',
      view_options = { show_hidden = true },
    },
    keys = {
      { '<leader>pv', '<cmd>Oil<cr>', desc = 'Open current directory with Oil' },
    },
  },
  -- Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true })() end,
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
  -- Commenting support
  { 'numToStr/Comment.nvim', config = true },
  -- Helper for viewing which keybind you are using
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },
  -- Helps in acessing most accessed files
  {
    'ThePrimeagen/harpoon',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = { global_settings = { save_on_toggle = true } },
    keys = {
      { '<leader>hm', function() require("harpoon.mark").add_file() end, desc = 'Mark current file to harpoon' },
      {
        '<leader>hl',
        function() require("harpoon.ui").toggle_quick_menu() end,
        desc = 'Show list of marked files with harpoon',
      },
    },
  },
}
