local conform = require("conform")

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

vim.keymap.set("n", "<leader>f", function()
  conform.format({ async = true })
end, { desc = "Run [F]ormatters" })

vim.api.nvim_create_user_command("ConformFormat", function(args)
  local range = nil

  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end

  conform.format({ async = true, range = range })
end, { range = true })

conform.setup({
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
  },
})
