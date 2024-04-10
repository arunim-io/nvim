return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    dependencies = { "windwp/nvim-ts-autotag" },
    opts = {
      auto_install = true,
      snippet_engine = "luasnip",
      highlight = { enable = true },
      incremental_selection = { enable = true },
      indent = { enable = true },
      autotag = { enable = true, enable_close_on_slash = true },
    },
  },
  {
    "calops/hmts.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "nix",
  },
}
