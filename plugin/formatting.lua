MiniDeps.add("stevearc/conform.nvim")

local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    ["*"] = { "trim_newlines", "trim_whitespace" },
    lua = { "stylua" },
    fish = { "fish_indent" },
    sh = { "shfmt" },
  },
  default_format_opts = {
    async = false,
    quiet = false,
    lsp_format = "fallback",
    timeout_ms = 3000,
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
  formatters = {
    injected = {
      options = {
        ignore_errors = true,
      },
    },
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set({ "n", "v" }, "<leader>ff", function()
  conform.format({ async = true }, function(err)
    if err then
      return
    end

    local mode = vim.api.nvim_get_mode().mode

    if vim.startswith(string.lower(mode), "v") then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    end
  end)
end, { desc = "Run formatters" })
