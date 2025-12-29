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

--- A table containing useful helpers for configuring neovim
_G.anc = {}

--- The path where `mini.nvim` is used.
anc.mini_path = mini_path

--- A custom augroup for grouping custom autocmds.
anc.augroup = vim.api.nvim_create_augroup("custom-config", { clear = true })

--- Helper for creating autocmds
--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param opts vim.api.keyset.create_autocmd
function anc.new_autocmd(event, opts)
	if opts.group ~= nil then
		vim.notify(
			[[
      You can't set the `group` in this function.
      If you want to use a custom augroup, then use `nvim.api.nvim_create_autocmd()`.
      ]],
			vim.log.levels.WARN
		)
	end
	opts.group = anc.augroup

	vim.api.nvim_create_autocmd(event, opts)
end

--- A helper function to load plugins depending on the case if nvim is started with a file path.
_G.anc.now_or_later = vim.fn.argc(0) > 0 and MiniDeps.now or MiniDeps.later
