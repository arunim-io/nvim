return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      "MaximilianLloyd/adjacent.nvim",
      "debugloop/telescope-undo.nvim",
      "smilovanovic/telescope-search-dir-picker.nvim",
    },
    config = function()
      local telescope = require 'telescope'

      telescope.load_extension 'fzf'
      telescope.load_extension 'adjacent'
      telescope.load_extension "undo"
      telescope.load_extension "search_dir_picker"
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
          function() require('search_dir_picker').search_dir() end,
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
