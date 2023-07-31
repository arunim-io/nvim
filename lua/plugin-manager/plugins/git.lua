return {
  { 'lewis6991/gitsigns.nvim', config = true },
  {
    "NeogitOrg/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Open Neogit' },
    },
  },
  {
    'olacin/telescope-cc.nvim',
    init = function() require('telescope').load_extension("conventional_commits") end,
    keys = {
      { "cg", "<cmd>Telescope conventional_commits<cr>", desc = 'commit using conventional commits' },
    },
  },
}
