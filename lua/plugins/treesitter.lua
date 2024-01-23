return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        sync_install = true,
        auto_install = true,
        snippet_engine = "luasnip",
      })
    end,
  },
  { "calops/hmts.nvim", version = "*", ft = "nix", dependencies = "nvim-treesitter/nvim-treesitter" },
}
