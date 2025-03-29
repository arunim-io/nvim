MiniDeps.add({
  source = "luckasRanarison/tailwind-tools.nvim",
  depends = {
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  hooks = {
    post_checkout = function()
      vim.cmd("UpdateRemotePlugins")
    end,
  },
})

require("tailwind-tools").setup({
  server = {
    --- @param client vim.lsp.Client
    --- @param bufnr integer
    on_attach = function(client, bufnr)
      client.capabilities = require("blink.cmp").get_lsp_capabilities(client.capabilities, true)

      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "TailwindSortSync",
      })
    end,
  },
})
