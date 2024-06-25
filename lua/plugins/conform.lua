vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local function format()
  require("conform").format({ async = true, lsp_fallback = true })
end

vim.keymap.set({ "n", "v" }, "<leader>f", format, { desc = "Format current file" })

require("conform").setup({
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
  formatters_by_ft = {
    ["_"] = { { "biome", "prettierd" } },
    lua = { "stylua" },
    nix = { "nixfmt" },
    toml = { "taplo" },
  },
})
