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

local tailwind_tools_state = require("tailwind-tools.state")

Snacks.toggle
  .new({
    name = "Tailwind Tools Colour highlighting",
    get = function()
      return tailwind_tools_state.color.enabled
    end,
    set = function()
      vim.cmd("TailwindColorToggle")
    end,
  })
  :map("<leader>ttc")

Snacks.toggle
  .new({
    name = "Tailwind Tools Conceal",
    get = function()
      return tailwind_tools_state.conceal.enabled
    end,
    set = function()
      vim.cmd("TailwindConcealToggle")
    end,
  })
  :map("<leader>tth")

local sort_classes = true

Snacks.toggle
  .new({
    name = "Tailwind Tools class Sorting",
    get = function()
      return sort_classes
    end,
    set = function(state)
      sort_classes = state
    end,
  })
  :map("<leader>tts")

---@diagnostic disable-next-line: missing-fields
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
