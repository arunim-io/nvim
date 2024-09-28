require("tmux").setup({
  navigation = { enable_default_keybindings = false },
  resize = { enable_default_keybindings = false },
})

vim.keymap.set("n", "<C-Up>", require("tmux").move_top, { desc = "navigate [Up]" })
vim.keymap.set("n", "<C-Down>", require("tmux").move_bottom, { desc = "navigate [Down]" })
vim.keymap.set("n", "<C-Left>", require("tmux").move_left, { desc = "navigate [Left]" })
vim.keymap.set("n", "<C-Right>", require("tmux").move_right, { desc = "navigate [Right]" })
