local add = MiniDeps.add

anc.now_or_later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
	})
	add({
		source = "nvim-treesitter/nvim-treesitter-textobjects",
		checkout = "main",
	})
	add("JoosepAlviste/nvim-ts-context-commentstring")
	add("windwp/nvim-ts-autotag")
	add("m-demare/hlargs.nvim")

	local ts = require("nvim-treesitter")

	--- @type string[]
	anc.required_ts_parsers = {
		"astro",
		"css",
		"dockerfile",
		"go",
		"html",
		"json",
		"json5",
		"lua",
		"markdown",
		"nu",
		"python",
		"rust",
		"sql",
		"templ",
		"toml",
		"vimdoc",
		"yaml",
		"zig",
	}

	local parsers_to_install = vim.tbl_filter(
		function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end,
		anc.required_ts_parsers
	)

	if #parsers_to_install > 0 then ts.install(parsers_to_install) end

	--- @type string[]
	local fts = {}
	for _, lang in ipairs(anc.required_ts_parsers) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(fts, ft)
		end
	end
	anc.new_autocmd("FileType", {
		desc = "Install missing treesitter parsers on demand & start treesitter for current buffer",
		pattern = fts,
		callback = function(args)
			local ft = vim.bo[args.buf].filetype
			for _, filetype in ipairs(anc.required_ts_parsers) do
				if filetype ~= ft then ts.install(ft):wait() end
			end

			vim.treesitter.start(args.buf)
		end,
	})

	vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.wo[0][0].foldmethod = "expr"

	vim.opt.updatetime = 100
	require("ts_context_commentstring").setup({
		enable_autocmd = package.loaded["mini.comment"],
	})

	require("nvim-ts-autotag").setup({
		opts = { enable_close_on_slash = true },
	})

	require("hlargs").setup({
		paint_catch_blocks = {
			declarations = true,
			usages = true,
		},
		extras = { named_parameters = true },
	})
end)
