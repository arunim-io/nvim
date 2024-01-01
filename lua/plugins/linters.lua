return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function(_, opts)
		require("lint").linters_by_ft = opts

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
	opts = {
		bash = { "shellcheck" },
		djangohtml = { "djlint" },
		lua = { "selene" },
		sh = { "shellcheck" },
	},
}
