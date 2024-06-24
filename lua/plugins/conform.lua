vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format current file" })

require("conform").setup({
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
  formatters_by_ft = {
    ["_"] = { { "biome", "prettierd" } },
    lua = { "stylua" },
    nix = { "nixfmt" },
    toml = { "taplo" },
  },
})
