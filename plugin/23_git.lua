require("mini.diff").setup({
  mappings = {
    apply = "<leader>gs",
    reset = "<leader>gr",
  },
})
require("mini.git").setup()

vim.keymap.set("n", "<leader>gS", "<cmd>Git add %<cr>", { desc = "Git add current file" })
vim.keymap.set("n", "<leader>gR", "<cmd>Git add %<cr>", { desc = "Git remove current file" })
