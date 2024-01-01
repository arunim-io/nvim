local lsp_zero = require("lsp-zero")
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr, omit = { "<F2>", "<F3>", "<F4>", "gl" } })

  local maps = vim.lsp.buf
  local map = vim.keymap.set

  local function opts(desc)
    return { desc = desc, buffer = client.buf }
  end

  map("n", "<leader>f", maps.format, opts("Format current file"))
  map("n", "<leader>ca", maps.code_action, opts("Open code action menu"))
  map("n", "<leader>rn", maps.rename, opts("Rename current word"))
end)

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({})

lspconfig.nil_ls.setup({})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.jsonls.setup({
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})

lspconfig.taplo.setup({})

lspconfig.astro.setup({})
lspconfig.bashls.setup({})
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.dockerls.setup({})
lspconfig.eslint.setup({
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", { buffer = bufnr, command = "EslintFixAll" })
  end,
})
lspconfig.pyright.setup({})
lspconfig.ruff_lsp.setup({})
lspconfig.statix.setup({})
lspconfig.svelte.setup({})
lspconfig.tailwindcss.setup({})
