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

require("nvim-autopairs").setup({
	check_ts = true,
	disable_in_visualblock = true,
	map_c_h = true,
	enable_check_bracket_line = true,
	enable_abbr = true,
  fast_wrap = { map = "<C-e>" },
})

if nixCats("language-support.completion") then
	require("cmp").event:on("conform_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
end
