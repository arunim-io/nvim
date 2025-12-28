local add = MiniDeps.add

Config.now_or_later(function()
	add("neovim/nvim-lspconfig")
	add("folke/lazydev.nvim")
	add("b0o/schemastore.nvim")

	vim.lsp.enable({ "lua_ls", "jsonls", "yamlls" })

	require("lazydev").setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			Config.mini_path,
		},
	})
end)
