MiniDeps.add({
  source = "nvimdev/guard.nvim",
  depends = { "nvimdev/guard-collection" },
})

vim.g.guard_config = {
  lsp_as_default_formatter = true,
}

local ft = require("guard.filetype")

ft("lua"):fmt("stylua"):lint("selene")
