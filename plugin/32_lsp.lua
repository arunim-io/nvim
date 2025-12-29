local add = MiniDeps.add

anc.now_or_later(function()
	add("neovim/nvim-lspconfig")
	add("folke/lazydev.nvim")
	add("b0o/schemastore.nvim")

	vim.lsp.enable({ "lua_ls", "jsonls", "yamlls" })

	require("lazydev").setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			anc.mini_path,
		},
	})
end)
