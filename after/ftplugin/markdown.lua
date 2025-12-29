vim.keymap.del("n", "gO", { buffer = 0 })

vim.b.minisurround_config = {
	custom_surroundings = {
		L = {
			input = { "%[().-()%]%(.-%)" },
			output = function()
				local link = MiniSurround.user_input("Link: ")
				return { left = "[", right = "](" .. link .. ")" }
			end,
		},
	},
}
