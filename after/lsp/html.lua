--- @type vim.lsp.Config
return {
	on_attach = function(client) client.capabilities.textDocument.completion.completionItem.snippetSupport = true end,
	init_options = { provideFormatter = false },
}
