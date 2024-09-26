local which_key = require("which-key")

which_key.setup({})

vim.keymap.set("n", "<leader>?", function()
	which_key.show({ global = false })
end, { desc = "Show buffer local Keymaps" })

require("mini.files").setup({
	mappings = {
		synchronize = "s",
		go_in = "<Right>",
		go_out = "<Left>",
		go_in_plus = "",
		go_out_plus = "",
	},
})

vim.keymap.set("n", "<leader>pv", MiniFiles.open, { desc = "[V]iew files in root directory" })
