local add = MiniDeps.add

add("neovim/nvim-lspconfig")
add("b0o/schemastore.nvim")

local servers = {}

servers.jsonls = {
  on_new_config = function(new_config)
    ---@diagnostic disable-next-line: inject-field
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      format = { enable = false },
      validate = { enable = true },
    },
  },
}

servers.yamlls = {
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
  on_new_config = function(new_config)
    new_config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
    },
  },
}

servers.lua_ls = {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      doc = { privateName = { "^_" } },
      format = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
}

servers.basedpyright = {
  settings = {
    basedpyright = { disableOrganizeImports = true },
    python = {
      analsysis = {
        ignore = { "*" },
      },
    },
  },
}

servers.ruff = {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
  settings = {
    ruff = {
      cmd_env = { RUFF_TRACE = "messages" },
      init_options = {
        settings = { logLevel = "error" },
      },
    },
  },
}

servers.taplo = {
  settings = {
    formatter = { allowed_blank_lines = 1 },
  },
}

servers.html = {
  init_options = { provideFormatter = false },
  on_attach = function(client)
    client.capabilities.textDocument.completion.completionItem.snippetSupport = true
  end,
}

servers.emmet_language_server = {}

servers.cssls = {
  init_options = { provideFormatter = false },
}

servers.ts_ls = {}

for name, config in pairs(servers) do
  config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities, true)

  require("lspconfig")[name].setup(config)
end

add("folke/lazydev.nvim")

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    _G.Config.mini_path,
  },
})
