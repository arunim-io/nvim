local telescope = require("telescope")

telescope.setup({
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
  },
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>pfr", builtin.find_files, { desc = "[F]ind files in [R]oot directory." })
vim.keymap.set("n", "<leader>pfg", builtin.git_files, { desc = "[F]ind files in [G]it directory." })
vim.keymap.set("n", "<leader>pfo", function()
  builtin.oldfiles({
    cwd = vim.fn.expand("%:p:h"),
  })
end, { desc = "[F]ind recently [O]pened files." })
vim.keymap.set("n", "<leader>pfa", function()
  builtin.find_files({
    prompt_title = "Find adjacent files",
    cwd = vim.fn.expand("%:p:h"),
  })
end, { desc = "[F]ind files in the directory [A]djacent to current buffer." })

vim.keymap.set("n", "<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set("n", "<leader>pbl", function()
  require("telescope.builtin").buffers({ only_cwd = true, sort_lastused = true })
end, { desc = "[L]earch [B]uffers" })
vim.keymap.set("n", "<leader>pbs", builtin.current_buffer_fuzzy_find, { desc = "[S]earch in current [B]uffer" })
