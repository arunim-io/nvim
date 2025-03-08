local add = MiniDeps.add

add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = "master",
  depends = {},
  hooks = {
    post_checkout = function()
      vim.cmd("TSUpdate")
    end,
  },
})

--- @diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = { "vimdoc", "lua", "toml" },
  auto_install = true,
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})

add("JoosepAlviste/nvim-ts-context-commentstring")

require("ts_context_commentstring").setup({
  enable_autocmd = false,
})

add("windwp/nvim-ts-autotag")

---@diagnostic disable-next-line: missing-fields
require("nvim-ts-autotag").setup({
  opts = { enable_close_on_slash = true },
})
