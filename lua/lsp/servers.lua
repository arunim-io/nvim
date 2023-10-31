local lspconfig = require 'lspconfig'
local lsp = require 'lsp-zero'
local schema_store = require 'schemastore'

lsp.extend_lspconfig()

local snippet_capabilities = require('lsp.utils').setup_snippet_capabilities()

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

-- Structured languages
lspconfig.taplo.setup {}
lspconfig.jsonls.setup {
  capabilities = snippet_capabilities,
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

-- Python development
lspconfig.pyright.setup {}
lspconfig.ruff_lsp.setup {}

-- Web development
lspconfig.html.setup { capabilities = snippet_capabilities }
lspconfig.cssls.setup { capabilities = snippet_capabilities }
lspconfig.tsserver.setup {}
lspconfig.eslint.setup {}
lspconfig.tailwindcss.setup {}
lspconfig.svelte.setup {}
lspconfig.astro.setup {}

-- misc
lspconfig.nil_ls.setup {}
lspconfig.dockerls.setup {}
lspconfig.bashls.setup {}
