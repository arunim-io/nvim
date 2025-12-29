MiniDeps.later(function()
	MiniDeps.add("stevearc/conform.nvim")

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

	function _G.Config.fmt_func()
		require("conform").format({ async = true }, function(err)
			if err then return end

			if vim.startswith(string.lower(vim.api.nvim_get_mode().mode), "v") then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", true)
			end
		end)
	end
end)
