local nixCatsUtils = require("nixCatsUtils")
---@diagnostic disable: missing-fields
--- @class LSPConfig
--- @field servers table<string, lspconfig.Config>
--- @field keys { [1]: string; [2]: function; desc: string?; }[]

local completion_enabled = nixCats("completion") ~= nil
local formatting_disabled = nixCats("formatting") == nil

--- @type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = "saghen/blink.cmp",
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

      for name, config in pairs(opts.servers) do
        if completion_enabled then
          config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities, true)
        end

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
              format = { enable = formatting_disabled },
            },
          },
        },
        nil_ls = {},
        nixd = {
          settings = {
            nixd = {
              nixpkgs = { expr = "import <nixpkgs> {}" },
              formatting = { command = { "nixfmt" } },
            },
          },
        },
        jsonls = {
          on_new_config = function(new_config)
            ---@diagnostic disable-next-line: inject-field
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
            ---@diagnostic disable-next-line: inject-field
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
          init_options = {
            provideFormatter = formatting_disabled,
          },
          on_attach = function(client)
            client.capabilities.textDocument.completion.completionItem.snippetSupport = true
          end,
        },
        emmet_language_server = {},
        cssls = {
          init_options = {
            provideFormatter = formatting_disabled,
          },
        },
        templ = {},
        svelte = {},
        htmx = {},
        eslint = {
          filetypes = vim.list_extend(require("lspconfig.configs.eslint").default_config.filetypes, {
            "html",
            "markdown",
            "json",
            "jsonc",
            "yaml",
            "toml",
            "xml",
            "gql",
            "graphql",
            "css",
            "less",
            "scss",
            "pcss",
            "postcss",
          }),
          settings = {
            codeActionOnSave = { enable = true },
            experimental = { useFlatConfig = true },
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
        ts_ls = {},
        astro = {
          on_new_config = function(new_config, new_root_dir)
            if not new_config.init_options.typescript.tsdk then
              local ts_path = ""

              local project_root = vim.fs.find("node_modules", {
                type = "directory",
                path = new_root_dir,
                upward = true,
              })[1]

              if nixCatsUtils.isNixCats then
                ts_path = nixCatsUtils.getCatOrDefault("extras.typescript_path", "")
              end

              if project_root then
                if
                  vim.fs.find("pnpm-lock.yaml", {
                    type = "file",
                    path = new_root_dir,
                  })[1]
                then
                  ts_path = vim.fs.find(function(name)
                    return name:match("typescript@[^/]+/")
                  end, { type = "directory", path = vim.fs.joinpath(project_root, ".pnpm/") })
                else
                  ts_path = vim.fs.find("typescript", { type = "directory", path = project_root, upward = true })[1]
                end
              end

              if ts_path then
                ---@diagnostic disable-next-line: inject-field
                new_config.init_options.typescript.tsdk = require("lspconfig.util").path.join(ts_path, "lib")
              end
            end
          end,
        },
      },
    },
  },
  { "b0o/SchemaStore.nvim", version = false },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    --- @module 'lazydev'
    --- @type lazydev.Config
    opts = {
      library = {
        "lazy.nvim",
        { path = "luvit-meta/library", mods = { "libuv", "luv" }, words = { "vim%.uv", "uv", "luv" } },
        { path = (require("nixCats").nixCatsPath or "") .. "/lua", words = { "nixCats" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>ca", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr, remap = true, silent = true })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            check = {
              command = "clippy",
            },
            checkOnSave = true,
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    build = require("nixCatsUtils").lazyAdd(":UpdateRemotePlugins"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    --- @module 'tailwind-tools'
    --- @type TailwindTools.Option
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", { buffer = bufnr, command = "TailwindSortSync" })
        end,
        settings = {
          experimental = {
            classRegex = {
              { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            },
          },
        },
      },
    },
  },
}
