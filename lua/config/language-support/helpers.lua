local trouble = require("trouble")

trouble.setup({})

vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show [D]iagnostics for current buffer line" })

vim.keymap.set("n", "<leader>dd", function()
	trouble.toggle({
		mode = "diagnostics",
		filter = { buf = 0 },
	})
end, { desc = "Show [D]iagnostics for current buffer" })
vim.keymap.set("n", "<leader>dw", function()
	trouble.toggle("diagnostics")
end, { desc = "Show [D]iagnostics for current [W]orkspace" })
