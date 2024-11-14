--- @class LSPConfig
--- @field servers table<string, lspconfig.Config>
--- @field keys { [1]: string; [2]: function; desc: string?; }[]

return {
  {
    "neovim/nvim-lspconfig",
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
        config.capabilities = vim.tbl_deep_extend("keep", config.capabilities or {}, capabilities)

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
              format = { enable = nixCats("formatting") == nil },
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
          init_options = { provideFormatter = nixCats("formatting") == nil },
        },
        emmet_language_server = {},
        cssls = {
          init_options = { provideFormatter = nixCats("formatting") == nil },
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
      },
    },
  },
  { "b0o/SchemaStore.nvim", version = false },
}
