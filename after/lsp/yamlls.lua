--- @type vim.lsp.Config
return {
	settings = {
		yaml = {
			redhat = { telemetry = { enabled = false } },
			schemas = require("schemastore").yaml.schemas(),
			schemaStore = { enable = false, url = "" },
		},
	},
}
