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
ANC = {}

--- The path where `mini.nvim` is used.
ANC.mini_path = mini_path

--- A custom augroup for grouping custom autocmds.
ANC.augroup = vim.api.nvim_create_augroup("custom-config", { clear = true })

--- Helper for creating autocmds
--- @param event vim.api.keyset.events|vim.api.keyset.events[]
--- @param opts vim.api.keyset.create_autocmd
function ANC.new_autocmd(event, opts)
	if opts.group ~= nil then
		vim.notify(
			[[
      You can't set the `group` in this function.
      If you want to use a custom augroup, then use `nvim.api.nvim_create_autocmd()`.
      ]],
			vim.log.levels.WARN
		)
	end
	opts.group = ANC.augroup

	vim.api.nvim_create_autocmd(event, opts)
end

--- A helper function to load plugins depending on the case if nvim is started with a file path.
ANC.now_or_later = vim.fn.argc(0) > 0 and MiniDeps.now or MiniDeps.later
