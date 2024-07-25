---@type LazySpec
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
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format buffer in view",
    },
  },
  ---@type conform.setupOpts
  opts = {
    format_on_save = {
      timeout_ms = 500,
    },
    formatters_by_ft = {
      ["_"] = { "prettierd" },
      css = { "biome" },
      jsx = { "biome" },
      tsx = { "biome" },
      js = { "biome" },
      ts = { "biome" },
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
