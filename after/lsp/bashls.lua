--- @type vim.lsp.Config
return {
	settings = {
		bashIde = {
			enableSourceErrorDiagnostics = true,
			shfmt = {
				caseIndent = true,
				simplifyCode = true,
				spaceRedirects = true,
			},
		},
	},
}
