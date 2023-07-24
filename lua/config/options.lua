local globals = vim.g
local options = vim.opt

globals.mapleader = ' '

globals.loaded_netrw = 1
globals.loaded_netrwPlugin = 1

options.number = true

options.tabstop = 2
options.softtabstop = 2
options.shiftwidth = 2
options.expandtab = true

options.smartindent = true
options.wrap = true

options.swapfile = false
options.backup = false
---@diagnostic disable-next-line: assign-type-mismatch
options.undodir = os.getenv('HOME') .. '/.vim/undodir'
options.undofile = true

options.hlsearch = false
options.incsearch = true

options.termguicolors = true

vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

options.updatetime = 25
