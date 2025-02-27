MiniDeps.add({
  source = "nvimdev/guard.nvim",
  depends = { "nvimdev/guard-collection" },
})

vim.g.guard_config = {
  lsp_as_default_formatter = true,
}

vim.keymap.set({ "n", "v" }, "<leader>ff", "<cmd>Guard fmt<esc>", { desc = "Format code" })
vim.keymap.set("n", "<leader>fl", "<cmd>Guard lint<esc>", { desc = "lint code" })

local ft = require("guard.filetype")

ft("lua"):fmt("stylua"):lint("selene")
