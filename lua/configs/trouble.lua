local trouble = require("trouble")

trouble.setup({
  auto_close = true,
})

vim.keymap.set("n", "<leader>dw", function()
  trouble.toggle("diagnostics")
end, { desc = "Show diagnostics for current project" })
vim.keymap.set("n", "<leader>dd", function()
  trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
end, { desc = "Show diagnostics for current file" })
