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

require("rust-tools").setup {
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set('n', '<leader>ca', '<cmd>RustCodeAction<cr>', { buffer = bufnr })
    end,
  },
}

local function setup_flutter_tools(lsp)
  require('flutter-tools').setup {
    lsp = {
      capabilities = lsp.build_options('dartls', {}).capabilities,
    }
  }
end

lspconfig.dartls.setup {}

lspconfig.cssls.setup {}

lspconfig.tailwindcss.setup {}

lspconfig.eslint.setup {}

lspconfig.nil_ls.setup {}

lspconfig.taplo.setup {}

lspconfig.pyright.setup {}

lspconfig.dockerls.setup {}

lspconfig.svelte.setup {}

return { setup_flutter_tools = setup_flutter_tools }
