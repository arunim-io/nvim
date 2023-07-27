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
}
