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
      ["_"] = { "prettier" },
      djangohtml = { "djlint" },
      lua = { "stylua" },
      nix = { "nixpkgs_fmt" },
      python = { "black", "ruff_fix" },
      sh = { "shfmt" },
      toml = { "taplo" },
    },
  },
}
