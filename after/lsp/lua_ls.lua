--- @type vim.lsp.Config
return {
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			doc = { privateName = { "^_" } },
			format = { enable = false },
			workspace = { checkThirdParty = false },
		},
	},
}
