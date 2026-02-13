local add, now_or_later = MiniDeps.add, ANC.now_or_later

now_or_later(function()
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
	ANC.required_ts_parsers = {
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
		ANC.required_ts_parsers
	)

	if #parsers_to_install > 0 then ts.install(parsers_to_install) end

	--- @type string[]
	local fts = {}
	for _, lang in ipairs(ANC.required_ts_parsers) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(fts, ft)
		end
	end
	ANC.new_autocmd("FileType", {
		desc = "Install missing treesitter parsers on demand & start treesitter for current buffer",
		pattern = fts,
		callback = function(args)
			local ft = vim.bo[args.buf].filetype
			for _, filetype in ipairs(ANC.required_ts_parsers) do
				if filetype ~= ft then ts.install(ft):wait() end
			end

			vim.treesitter.start(args.buf)
		end,
	})

	vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.wo[0][0].foldmethod = "expr"

	vim.opt.updatetime = 100
end)

now_or_later(function()
	require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
		local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
		local filename = vim.fn.fnamemodify(filepath, ":t")
		return string.match(filename, ".*mise.*%.toml$") ~= nil
	end, { force = true, all = false })
end)

now_or_later(
	function()
		require("ts_context_commentstring").setup({
			enable_autocmd = package.loaded["mini.comment"],
		})
	end
)

now_or_later(function()
	require("nvim-ts-autotag").setup({
		opts = { enable_close_on_slash = true },
	})
end)

now_or_later(
	function()
		require("hlargs").setup({
			paint_catch_blocks = {
				declarations = true,
				usages = true,
			},
			extras = { named_parameters = true },
		})
	end
)
