--- @type vim.lsp.Config
return {
	on_attach = function(client, bufnr)
		client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }
	end,
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			doc = { privateName = { "^_" } },
			format = { enable = false },
			workspace = {
				checkThirdParty = false,
				ignoreSubmodules = true,
			},
		},
	},
}
