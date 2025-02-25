require("mini.ai").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.surround").setup()
require("mini.bracketed").setup()
require("mini.files").setup()

MiniDeps.add("folke/which-key.nvim")

require("which-key").setup({
  preset = "helix",
})

MiniDeps.add("MagicDuck/grug-far.nvim")

local grug_far = require("grug-far")

grug_far.setup()

vim.keymap.set({ "n", "v" }, "<leader>rw", function()
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")

  grug_far.open({
    transient = true,
    prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
  })
end, { desc = "Search & replace" })
