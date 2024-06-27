local grug_far = require("grug-far")

vim.g.maplocalleader = ","

grug_far.setup()

vim.keymap.set("n", "<leader>rw", grug_far.grug_far, { desc = "Search within workspace" })

vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace current word with regex" }
)
