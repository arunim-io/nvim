return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
      local lsp = vim.lsp
      lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = {
          spacing = 5,
          severity_limit = "Warning",
        },
        update_in_insert = true,
      })

      require("nvim-treesitter.configs").setup({
        auto_install = true,
        snippet_engine = "luasnip",
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = true },
        autotag = {
          enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
        },
      })
    end,
  },
  {
    "calops/hmts.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "nix",
  },
}
