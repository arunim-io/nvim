return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>f",
			function() require("conform").format({ async = true, lsp_fallback = true }) end,
			mode = 'n',
			desc = "Format buffer in view",
		},
	},
	opts = {
		formatters_by_ft = {
			python = { "black" },
			javascript = { "prettierd" },
			nix = { "nixpkgs_fmt" },
		},
		format_on_save = { timeout_ms = 500, lsp_fallback = true },
	},
	init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
}
