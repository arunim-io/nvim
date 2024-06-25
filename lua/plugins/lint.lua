local lint = require("lint")

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    local client = vim.lsp.get_clients({ bufnr = 0 })[1] or {}

    lint.try_lint(nil, { cwd = client.root_dir })
  end,
})

lint.linters_by_ft = {
  lua = { "selene" },
  nix = { "statix" },
}
