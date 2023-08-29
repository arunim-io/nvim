local M = {}

local isNixOS = require('config.utils').isNixOS
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

function M.setup_flutter_tools(lsp)
  require('flutter-tools').setup {
    lsp = {
      capabilities = lsp.build_options('dartls', {}).capabilities,
    }
  }
end

lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
}

lspconfig.ruff_lsp.setup {
  on_attach = function(client, bufnr)
    local function format()
      vim.lsp.buf.format()
      vim.lsp.buf.code_action {
        context = {
          only = { 'source.fixAll.ruff' }
        },
        apply = true,
      }
    end

    vim.keymap.set('n', '<leader>f', format, { desc = 'Format current file' })
  end
}

if isNixOS then
  lspconfig.cssls.setup {}
  lspconfig.tailwindcss.setup {}
  lspconfig.nil_ls.setup {}
  lspconfig.taplo.setup {}
  lspconfig.pyright.setup {}
  lspconfig.dockerls.setup {}
  lspconfig.svelte.setup {}
  lspconfig.bashls.setup {}
end

function M.setup_lsps(lsp)
  if not isNixOS then
    lsp.ensure_installed {
      'cssls',
      'tailwindcss',
      'eslint',
      'taplo',
      'pyright',
      'ruff_lsp',
      'dockerls',
      'svelte',
      'bashls',
    }
  end
end

return M
