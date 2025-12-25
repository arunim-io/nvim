MiniDeps.later(function()
	MiniDeps.add("stevearc/conform.nvim")

	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	require("conform").setup({
		default_format_opts = { lsp_format = "first", timeout_ms = 3000 },
		format_on_save = { timeout_ms = 500 },
		formatters = {
			injected = {
				options = { ignore_errors = true },
			},
		},
		formatters_by_ft = {
			["*"] = { "trim_newlines", "trim_whitespace" },
			lua = { "stylua" },
		},
	})
end)
