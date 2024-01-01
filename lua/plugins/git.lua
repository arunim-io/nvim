return {
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, config = true },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "sindrets/diffview.nvim" },
    branch = "nightly",
    config = true,
    keys = {
      { "<leader>g", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    },
  },
}
