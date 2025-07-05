---@diagnostic disable: missing-fields
local add = MiniDeps.add

add("neovim/nvim-lspconfig")
add("b0o/schemastore.nvim")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local function map(key, action, desc_suffix)
      vim.keymap.set("n", key, vim.lsp.buf[action], { buffer = args.buf, desc = "LSP: " .. desc_suffix })
    end

    map("K", "hover", "hover documentation")
    map("gs", "signature_help", "signature help")
    map("gd", "definition", "go to definition")
    map("gD", "declaration", "go to declaration")
    map("gi", "implementation", "go to implementation")
    map("gt", "type_definition", "go to type definition")
    map("gR", "references", "go to references")
    map("<leader>ca", "code_action", "show code actions")
    map("<leader>rn", "rename", "rename")
  end,
})

--- @type table<string, vim.lsp.Config>
local servers = {}

servers.jsonls = {
  on_new_config = function(new_config)
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
  filetypes = { "html", "templ", "django-html", "htmldjango" },
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

servers.eslint = {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "html",
    "markdown",
    "json",
    "jsonc",
    "yaml",
    "toml",
    "xml",
    "gql",
    "graphql",
    "astro",
    "svelte",
    "css",
    "less",
    "scss",
    "pcss",
    "postcss",
  },
  settings = {
    codeActionOnSave = {
      enable = true,
    },
    problems = {
      shortenToSingleLine = true,
    },
    rulesCustomizations = {
      { rule = "style/*", severity = "off", fixable = true },
      { rule = "format/*", severity = "off", fixable = true },
      { rule = "*-indent", severity = "off", fixable = true },
      { rule = "*-spacing", severity = "off", fixable = true },
      { rule = "*-spaces", severity = "off", fixable = true },
      { rule = "*-order", severity = "off", fixable = true },
      { rule = "*-dangle", severity = "off", fixable = true },
      { rule = "*-newline", severity = "off", fixable = true },
      { rule = "*quotes", severity = "off", fixable = true },
      { rule = "*semi", severity = "off", fixable = true },
    },
  },
}

servers.nushell = {}

servers.zls = {}

servers.rust_analyzer = {}

servers.astro = {}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))

add("folke/lazydev.nvim")

---@diagnostic disable-next-line: missing-fields
require("lazydev").setup({
  library = {
    {
      path = "${3rd}/luv/library",
      words = { "vim%.uv" },
    },
    _G.Config.mini_path,
    { path = "snacks.nvim", words = { "Snacks" } },
  },
})

add({
  source = "jmbuhr/otter.nvim",
  depends = { "nvim-treesitter/nvim-treesitter" },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "toml" },
  callback = function()
    require("otter").activate()
  end,
})
