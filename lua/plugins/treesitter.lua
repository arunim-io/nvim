local M = {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true })() end,
    config=function() require("nvim-treesitter.configs").setup {
	sync_install=true,
	auto_install=true,
    } end,
}

return { M }
