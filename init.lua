vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

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
  path = {
    package = package_path,
  },
})
