MiniDeps.add({
  source = "xvzc/chezmoi.nvim",
  depends = { "nvim-lua/plenary.nvim" },
})

require("chezmoi").setup({})
