--- @class LSPConfig
--- @field servers table<string, lspconfig.Config>
--- @field keys { [1]: string; [2]: function; desc: string?; }[]

local completion_enabled = nixCats("completion") ~= nil
local formatting_disabled = nixCats("formatting") == nil

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { completion_enabled and "saghen/blink.cmp" },
    --- @param opts LSPConfig
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          for _, key in ipairs(opts.keys) do
            vim.keymap.set("n", key[1], key[2], {
              buffer = event.buf,
              desc = "LSP: " .. key.desc,
              noremap = true,
            })
          end
        end,
      })
      local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities())

      for name, config in pairs(opts.servers) do
        config.capabilities = completion_enabled and require("blink.cmp").get_lsp_capabilities(config.capabilities)
          or capabilities

        require("lspconfig")[name].setup(config)
      end
    end,
    --- @type LSPConfig
    opts = {
      keys = {
        { "K", vim.lsp.buf.hover, desc = "[H]over documentation" },
        { "gs", vim.lsp.buf.signature_help, desc = "[S]ignature Help" },
        { "gd", vim.lsp.buf.definition, desc = "[G]o to [D]efinition" },
        { "gD", vim.lsp.buf.declaration, desc = "[G]o to [D]eclaration" },
        { "gi", vim.lsp.buf.implementation, desc = "[G]o to [I]mplementation" },
        { "gt", vim.lsp.buf.type_definition, desc = "[G]o to [T]ype definition" },
        { "gr", vim.lsp.buf.references, desc = "[G]o to [R]eferences" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction" },
        { "<leader>rn", vim.lsp.buf.rename, desc = "[R]ename" },
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              format = { enable = nixCats("formatting") == nil },
            },
          },
        },
        nixd = {
          settings = {
            nixd = {
              nixpkgs = { expr = "import <nixpkgs> {}" },
              -- formatting = { command = { "nixfmt" } },
            },
          },
        },
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = { enable = formatting_disabled },
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          on_attach = function(client)
            -- Neovim < 0.10 does not have dynamic registration for formatting
            if vim.fn.has("nvim-0.10") == 0 then
              client.server_capabilities.documentFormattingProvider = true
            end
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
        },
        basedpyright = {
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
        },
        ruff = {
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
        },
        taplo = {
          settings = {
            formatter = { allowed_blank_lines = 1 },
          },
        },
        html = {
          filetypes = { "html", "htmldjango", "djangohtml" },
          init_options = { provideFormatter = formatting_disabled },
        },
        emmet_language_server = {},
        cssls = {
          init_options = { provideFormatter = formatting_disabled },
        },
        astro = {},
        svelte = {},
        htmx = {},
        eslint = {
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
        },
        gopls = {
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          on_attach = function(client)
            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens

              if semantic then
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end,
          settings = {
            gopls = {
              gofumpt = true,
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
    },
  },
  { "b0o/SchemaStore.nvim", version = false },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", mods = { "libuv", "luv" }, words = { "vim%.uv", "uv", "luv" } },
        { path = (require("nixCats").nixCatsPath or "") .. "/lua", words = { "nixCats" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
}
