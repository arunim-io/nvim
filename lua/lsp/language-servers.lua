local lspconfig = require 'lspconfig'
local schema_store = require 'schemastore'

lspconfig.jsonls.setup {
  settings = {
    json = {
      schemas = schema_store.json.schemas(),
      validate = { enable = true },
    },
  },
}

lspconfig.yamlls.setup {
  filetypes = { 'yml', 'yaml' },
  settings = {
    yaml = {
      schemas = schema_store.yaml.schemas(),
      schemaStore = { enable = false },
    },
  },
}

lspconfig.cssls.setup {}

lspconfig.eslint.setup {}

lspconfig.nil_ls.setup {}

lspconfig.taplo.setup {}

lspconfig.pyright.setup {}

require('rust-tools').setup {
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set('n', '<leader>ca', '<cmd>RustCodeAction<cr>', { buffer = bufnr })
    end,
  },
}
