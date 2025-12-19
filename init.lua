local package_path = vim.fs.joinpath(vim.fn.stdpath("data"), "/site")
local mini_path = vim.fs.joinpath(package_path, "/pack/deps/start/mini.nvim")
if not vim.uv.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		-- Uncomment next line to use 'stable' branch
		-- '--branch', 'stable',
		"https://github.com/nvim-mini/mini.nvim",
		mini_path,
	})
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({
	path = { package = package_path },
})

--- A config table containing useful helpers for configuring neovim
_G.Config = {}

--- A custom augroup for grouping custom autocmds.
_G.Config.augroup = vim.api.nvim_create_augroup("custom-config", { clear = true })

--- Helper for creating autocmds
--- @param event string|string[]
--- @param opts vim.api.keyset.create_autocmd
function _G.Config.new_autocmd(event, opts)
	if opts.group == nil then opts.group = _G.Config.augroup end

	vim.api.nvim_create_autocmd(event, opts)
end

--- A helper function to load plugins depending on the case if nvim is started with a file path.
_G.Config.now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
