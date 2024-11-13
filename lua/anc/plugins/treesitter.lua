return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = require("nixCatsUtils").lazyAdd(":TSUpdate"),
    config = function()
      require("nvim-treesitter.install").prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        auto_install = require("nixCatsUtils").lazyAdd(true, false),
        sync_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },
}
