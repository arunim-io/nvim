return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer in view",
    },
  },
  opts = {
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters_by_ft = {
      ["_"] = { { "biome", "prettierd" } },
      htmldjango = { "djlint" },
      lua = { "stylua" },
      nix = { "nixfmt" },
      python = { "ruff_format", "ruff_fix" },
      sh = { "shfmt" },
      fish = { "fish_indent" },
      toml = { "taplo" },
    },
  },
}
