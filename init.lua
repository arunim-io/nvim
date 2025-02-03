---@diagnostic disable: missing-fields

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"

local mini_path = path_package .. "pack/deps/start/mini.nvim"

if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')

  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)

  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({ path = { package = path_package } })

require("mini.completion").setup()

local add = MiniDeps.add

add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = "master",
  monitor = "main",
  hooks = {
    post_checkout = function()
      vim.cmd("TSUpdate")
    end,
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vimdoc" },
  sync_install = true,
  highlight = { enable = true },
})

add({
  source = "neovim/nvim-lspconfig",
  depends = { "williamboman/mason.nvim" },
})

require("lspconfig").lua_ls.setup({})

add("folke/lazydev.nvim")

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

add({
  source = "nvimdev/guard.nvim",
  depends = { "nvimdev/guard-collection" },
})

local ft = require("guard.filetype")

vim.g.guard_config = {}

ft("lua"):fmt("stylua"):lint("selene")
