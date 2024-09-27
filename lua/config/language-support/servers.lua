local isNix = require("nixCatsUtils").isNixCats

if isNix and nixCats("lspDebugMode") then
  vim.lsp.set_log_level("debug")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

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
      format = {
        enable = true,
      },
    },
  },
}

if isNix then
  servers.nixd = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = [[import (builtins.getFlake "]] .. nixCats("extras.nixpkgs") .. [[") { }   ]],
        },
        formatting = {
          command = { "nixfmt" },
        },
        diagnostic = {
          suppress = {
            "sema-escaping-with",
          },
        },
      },
    },
  }
  -- If you integrated with your system flake,
  -- you should pass inputs.self.outPath as extras.flake-path
  -- that way it will ALWAYS work, regardless
  -- of where your config actually was.
  -- otherwise flake-path could be an absolute path to your system flake, or nil or false
  if nixCats("extras.flake-path") and nixCats("extras.systemCFGname") and nixCats("extras.homeCFGname") then
    vim.tbl_deep_extend("keep", servers.nixd.settings.nixd, {
      options = {
        -- (builtins.getFlake "<path_to_system_flake>").nixosConfigurations."<name>".options
        nixos = {
          expr = [[(builtins.getFlake "]]
              .. nixCats("extras.flake-path")
              .. [[").nixosConfigurations."]]
              .. nixCats("extras.systemCFGname")
              .. [[".options]],
        },
        -- (builtins.getFlake "<path_to_system_flake>").homeConfigurations."<name>".options
        ["home-manager"] = {
          expr = [[(builtins.getFlake "]]
              .. nixCats("extras.flake-path")
              .. [[").homeConfigurations."]]
              .. nixCats("extras.homeCFGname")
              .. [[".options]],
        },
      },
    })
  end
else
  servers.nil_ls = {}
end

local schemastore = require 'schemastore'

servers.jsonls = {
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true }
    }
  }
}

servers.yamlls = {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = schemastore.yaml.schemas(),
    },
  },
}

for name, config in pairs(servers) do
  if nixCats("language-support.completion") then
    config.capabilities = capabilities
  end

  require("lspconfig")[name].setup(config)
end

return { lsp_augroup = augroup }
