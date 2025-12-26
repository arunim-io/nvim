--- @type vim.lsp.Config
return {
	settings = {
		json = {
			format = { enable = false },
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}
