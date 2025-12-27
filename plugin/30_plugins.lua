--[[ Setup `grug-far.nvim` for Find and Replace. ]]
Config.now_if_args(function()
	MiniDeps.add("MagicDuck/grug-far.nvim")

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
