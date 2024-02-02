return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        snippet_engine = "luasnip",
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  { "calops/hmts.nvim", version = "*", ft = "nix", dependencies = "nvim-treesitter/nvim-treesitter" },
}
