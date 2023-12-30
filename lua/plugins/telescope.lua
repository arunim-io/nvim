return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		"smilovanovic/telescope-search-dir-picker.nvim",
		"MaximilianLloyd/adjacent.nvim",
	},
	init = function()
		require('telescope').load_extension('fzf')
		require('telescope').load_extension('search_dir_picker')
		require('telescope').load_extension('adjacent')
	end,
	opts = {},
	keys = {
		{ '<leader>pf',  "<cmd>Telescope find_files<cr>",        desc = 'Open root directory with Telescope' },
		{ '<leader>b',   "<cmd>Telescope buffers<cr>",           desc = 'Open buffers with Telescope' },
		{ '<leader>ps',  "<cmd>Telescope search_dir_picker<cr>", desc = 'Search cwd with Telescope' },
		{ "<leader>pfa", "<cmd>Telescope adjacent<cr>",          desc = 'Open adjacent files with Telescope', noremap = true, silent = false, },
	},
}
