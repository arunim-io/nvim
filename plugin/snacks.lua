MiniDeps.add("folke/snacks.nvim")

require("snacks").setup({
  bigfile = { enabled = true },
  toggle = { enabled = true },
  lazygit = {},
  quickfile = {},
  words = { enabled = true },
})

Snacks.toggle.dim():map("<leader>td")

vim.keymap.set("n", "<leader>bdd", Snacks.bufdelete.delete, { desc = "Delete current buffer" })
vim.keymap.set("n", "<leader>bda", Snacks.bufdelete.all, { desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>bdo", Snacks.bufdelete.other, { desc = "Delete all buffers except current one" })

vim.keymap.set("n", "<leader>gg", Snacks.lazygit.open, { desc = "Delete all buffers except current one" })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

vim.keymap.set("n", "<leader>rf", Snacks.rename.rename_file, { desc = "Rename current file" })

vim.keymap.set("n", "<leader>s.", Snacks.scratch.open, { desc = "Toggle Scratch Buffer" })
vim.keymap.set("n", "<leader>ss", Snacks.scratch.select, { desc = "Select Scratch Buffer" })
vim.keymap.set("n", "<leader>sl", Snacks.scratch.list, { desc = "list Scratch Buffer" })
vim.keymap.set({ "n", "t" }, "[[", function()
  Snacks.words.jump(vim.v.count1)
end, { desc = "Jump to previous reference" })
vim.keymap.set({ "n", "t" }, "]]", function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = "Jump to next reference" })

vim.keymap.set("n", "<leader>pp", function()
  Snacks.picker()
end, { desc = "Find pickers" })
vim.keymap.set("n", "<leader>bl", Snacks.picker.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>pf", Snacks.picker.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>ps", function()
  Snacks.input.input({ prompt = "Search" }, function(value)
    if value then
      Snacks.picker.grep_word({ search = value })
    end
  end)
end, { desc = "Grep search" })
