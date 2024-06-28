local telescope, builtins = require("telescope"), require("telescope.builtin")

telescope.setup()

telescope.load_extension("fzf")
telescope.load_extension("undo")

vim.keymap.set("n", "<leader>pfr", builtins.find_files, { desc = "Find files in the root directory" })
vim.keymap.set("n", "<leader>pfg", builtins.git_files, { desc = "Find files tracked by git" })
vim.keymap.set("n", "<leader>pfa", function()
  builtins.find_files({
    prompt_title = "Find adjacent files",
    cwd = vim.fn.expand("%:p:h"),
  })
end, { desc = "Find files adjacent to the currently opened file" })

vim.keymap.set("n", "<leader>u", telescope.extensions.undo.undo, { desc = "View undotree with Telescope" })

vim.keymap.set("n", "<leader>ps", function()
  builtins.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Search using grep" })
vim.keymap.set("n", "<leader>pws", function()
  builtins.grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Search current word using grep" })
