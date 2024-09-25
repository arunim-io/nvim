local cmp = require("cmp")

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" },
	}, {
		{ name = "buffer" },
	}),
})
require("cmp_git").setup()

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	---@diagnostic disable-next-line: missing-fields
	matching = { disallow_symbol_nonprefix_matching = false },
})

local sources = {
	{ name = "nvim_lsp" },
	{ name = "luasnip" },
}

if nixCats("language-support.lsp") and pcall(require, "lazydev") then
	table.insert(sources, { name = "lazydev", group_index = 0 })
end

cmp.setup({
	sources = cmp.config.sources(sources, {
		{ name = "buffer" },
	}),
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})
