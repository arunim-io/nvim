return {
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "hrsh7th/cmp-nvim-lsp",
    config = function()
      require("lsp")
    end,
  },
  { "lvimuser/lsp-inlayhints.nvim", config = true, event = "LspAttach" },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "LspAttach",
    config = true,
    keys = {
      {
        "<leader>dd",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Show diagnostics for current buffer",
      },
      {
        "<leader>dw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Show diagnostics for current workspace",
      },
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    dependencies = "antoinemadec/FixCursorHold.nvim",
    event = "LspAttach",
    opts = {
      autocmd = { enabled = true },
    },
  },
  { "j-hui/fidget.nvim", event = "LspAttach", config = true },
  { "b0o/schemastore.nvim", ft = { "json", "jsonc", "toml", "yaml", "yml" } },
  { "folke/neodev.nvim", config = true, ft = "lua" },
  {
    "mrcjkb/rustaceanvim",
    version = "^3",
    ft = "rust",
    config = function()
      vim.g.rustaceanvim = {
        inlay_hints = { highlight = "NonText" },
        tools = { hover_actions = { auto_focus = true } },
        server = {
          on_attach = function(client, bufnr)
            require("lsp-inlayhints").on_attach(client, bufnr)
            vim.keymap.set("n", "<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, { silent = true, buffer = bufnr })
          end,
          settings = {
            ["rust-analyzer"] = { check = { command = "clippy" } },
          },
        },
      }
    end,
  },
  { "saecki/crates.nvim", event = "BufRead Cargo.toml", dependencies = "nvim-lua/plenary.nvim", config = true },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        complete_function_calls = true,
        jsx_close_tags = { enable = true },
      },
    },
  },
}
