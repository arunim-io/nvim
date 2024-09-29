local isNix = require("nixCatsUtils").isNixCats
local cmp_enabled = nixCats("language-support.completion")

if isNix and nixCats("lspDebugMode") then
  vim.lsp.set_log_level("debug")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

if cmp_enabled then
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true
end

--- @type table<string, lspconfig.Config>
local servers = {}

local augroup = vim.api.nvim_create_augroup("LSPConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "lua" },
  callback = function()
    vim.cmd.packadd("lazydev.nvim")

    require("lazydev").setup({
      library = {
        { path = require("nixCats").nixCatsPath .. "/lua", words = { "nixCats" } },
      },
    })
  end,
})

servers.lua_ls = {
  settings = {
    Lua = {
      format = { enable = false },
    },
  },
}

servers.nixd = {
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
      diagnostic = {
        suppress = { "sema-escaping-with" },
      },
    },
  },
}

local nixpkgs_path = nixCats("extras.nixpkgs")

servers.nil_ls = {}

if isNix and nixpkgs_path then
  vim.tbl_deep_extend("keep", servers.nixd.settings.nixd, {
    nixpkgs = {
      expr = [[import (builtins.getFlake "]] .. nixpkgs_path .. [[") { }   ]],
    },
  })
end

-- If you integrated with your system flake,
-- you should pass inputs.self.outPath as extras.flake-path
-- that way it will ALWAYS work, regardless
-- of where your config actually was.
-- otherwise flake-path could be an absolute path to your system flake, or nil or false
-- NOTE: This might be cleanly done with a plugin like folke's neoconf
if nixCats("extras.flake-path") and nixCats("extras.systemCFGname") and nixCats("extras.homeCFGname") then
  vim.tbl_deep_extend("keep", servers.nixd.settings.nixd, {
    options = {
      -- (builtins.getFlake "<path_to_system_flake>").nixosConfigurations."<name>".options
      nixos = {
        expr = [[(builtins.getFlake "]] .. nixCats("extras.flake-path") .. [[").nixosConfigurations."]] .. nixCats(
          "extras.systemCFGname"
        ) .. [[".options]],
      },
      -- (builtins.getFlake "<path_to_system_flake>").homeConfigurations."<name>".options
      ["home-manager"] = {
        expr = [[(builtins.getFlake "]] .. nixCats("extras.flake-path") .. [[").homeConfigurations."]] .. nixCats(
          "extras.homeCFGname"
        ) .. [[".options]],
      },
    },
  })
end

local schemastore = require("schemastore")

servers.jsonls = {
  ---@param config lspconfig.Config
  on_new_config = function(config)
    vim.list_extend(config.settings.json.schemas or {}, schemastore.json.schemas())
  end,
  settings = {
    json = {
      format = { enable = false },
      validate = { enable = true },
    },
  },
}

servers.yamlls = {
  capabilities = vim.tbl_deep_extend("keep", capabilities, {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  }),
  on_new_config = function(config)
    config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  on_attach = function(client)
    -- Neovim < 0.10 does not have dynamic registration for formatting
    if vim.fn.has("nvim-0.10") == 0 then
      client.server_capabilities.documentFormattingProvider = true
    end
  end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      schemaStore = { enable = false, url = "" },
    },
  },
}

servers.basedpyright = {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
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
  filetypes = { "html", "htmldjango", "djangohtml" },
  init_options = { provideFormatter = false },
}
servers.emmet_language_server = {}
servers.cssls = {
  init_options = { provideFormatter = false },
}
servers.tailwindcss = {
  root_dir = require("lspconfig.util").root_pattern(
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.cjs",
    "postcss.config.mjs",
    "postcss.config.ts"
  ),
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  },
}
servers.astro = {}
servers.svelte = {}
servers.htmx = {}
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
    workingDirectories = { mode = "auto" },
  },
}
servers.biome = {}

for name, config in pairs(servers) do
  config.capabilities = config.capabilities or capabilities

  require("lspconfig")[name].setup(config)
end

return { lsp_augroup = augroup }
