local add = MiniDeps.add

--[[ Setup `grug-far.nvim` for Find and Replace. ]]
ANC.now_or_later(function()
	add("MagicDuck/grug-far.nvim")

	local grug_far = require("grug-far")

	grug_far.setup()

	function ANC.search_replace_func()
		local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")

		grug_far.open({
			transient = true,
			prefills = {
				filesFilter = ext and ext ~= "" and "*." .. ext or nil,
			},
		})
	end
end)

--[[ Setup `snacks.nvim` for some QoL features ]]
MiniDeps.now(function()
	add("folke/snacks.nvim")

	require("snacks").setup({
		bigfile = { enabled = true },
		image = { enabled = true },
		input = {},
		quickfile = {},
		scratch = { enabled = true },
		scroll = {},
	})

	ANC.new_autocmd("User", {
		pattern = "MiniFilesActionRename",
		callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
	})

	Snacks.toggle.option("wrap", { name = "Wrap" }):map("<Leader>tw")
end)

MiniDeps.later(function()
	add("chomosuke/typst-preview.nvim")

	require("typst-preview").setup()
end)

-- TODO: Setup Neogen, refactoring.nvim, a project config loader, chezmoi.nvim, otter.nvim
