return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("harpoon"):setup()
	end,
	keys = {
		{
			"<leader>hl",
			function()
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
			end,
			desc = "Show harpoon list",
		},
		{
			"<leader>ha",
			function()
				require("harpoon"):list():append()
			end,
			desc = "Add current file to harpoon",
		},
	},
}
