local add = MiniDeps.add

anc.now_or_later(function()
	add("neovim/nvim-lspconfig")
	add("folke/lazydev.nvim")
	add("b0o/schemastore.nvim")

	vim.lsp.enable({
		"astro",
		"basedpyright",
		"bashls",
		"biome",
		"cssls",
		"docker_compose_language_service",
		"docker_language_server",
		"dockerls",
		"emmet_language_server",
		"eslint",
		"gopls",
		"html",
		"jsonls",
		"kdl",
		"lua_ls",
		"nushell",
		"qmlls",
		"ruff",
		"rust_analyzer",
		"sqruff",
		"tailwindcss",
		"taplo",
		"templ",
		"typst",
		"yamlls",
		"zls",
	})

	require("lazydev").setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			anc.mini_path,
		},
	})
end)
