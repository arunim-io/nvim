---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform_loaded, conform = pcall(require, "conform")

  if not conform_loaded then
    return ...
  end

  for i = 1, select("#", ...) do
    local formatter = select(i, ...)

    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end

  return select(1, ...)
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      desc = "[F]ormat current buffer",
    },
  },
  opts = {
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = { timeout_ms = 500 },
    formatters_by_ft = {
      ["*"] = { "trim_newlines", "trim_whitespace" },
      ["_"] = function(bufnr)
        return { first(bufnr, "prettierd", "prettier") }
      end,
      lua = { "stylua" },
      djangohtml = { "djlint" },
      htmldjango = { "djlint" },
      nix = { "nixfmt" },
    },
  },
}
