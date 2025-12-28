local add = MiniDeps.add

--[[ Setup `grug-far.nvim` for Find and Replace. ]]
Config.now_or_later(function()
	add("MagicDuck/grug-far.nvim")

	local grug_far = require("grug-far")

	grug_far.setup()

	function _G.Config.search_replace_func()
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
		quickfile = {},
		scratch = { enabled = true },
		scroll = {},
	})

	Config.new_autocmd("User", {
		pattern = "MiniFilesActionRename",
		callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
	})

	Snacks.toggle.option("wrap", { name = "Wrap" }):map("<Leader>tw")
end)
