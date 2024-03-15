local lspconfig = require("lspconfig")

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local maps = vim.lsp.buf
    local function set(keymap, cmd, desc)
      vim.keymap.set("n", keymap, cmd, { buffer = event.buf, desc = desc })
    end

    set("K", maps.hover, "Show information about the symbol under the cursor")
    set("gd", maps.definition, "Show definition for the symbol under the cursor")
    set("gD", maps.declaration, "Go to the declaration of the symbol under the cursor")
    set("gi", maps.implementation, "Show implementation of the symbol under the cursor")
    set("gt", maps.type_definition, "Jump to definition of the symbol under the cursor")
    set("gr", maps.references, "List all the references of the symbol under the cursor")
    set("gs", maps.signature_help, "Show signature information about the symbol under the cursor")
    set("<leader>ca", maps.code_action, "Open code action menu")
    set("<leader>rn", maps.rename, "Rename current word")
  end,
})

---@param lsp string
---@param opts table|nil
local function setup_lsp(lsp, opts)
  opts = opts or {}
  opts["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
  lspconfig[lsp].setup(opts)
end

setup_lsp("lua_ls")
setup_lsp("nil_ls")
setup_lsp("taplo")
setup_lsp("dockerls")
setup_lsp("bashls")

setup_lsp("jsonls", {
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

setup_lsp("yamlls", {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})

setup_lsp("pyright")
setup_lsp("ruff_lsp")

setup_lsp("html", { filetypes = { "html", "htmldjango", "djangohtml" } })
setup_lsp("emmet_language_server")
setup_lsp("cssls", { filetypes = { "css", "scss", "less", "html", "htmldjango", "djangohtml" } })
setup_lsp("tailwindcss")
setup_lsp("astro")
setup_lsp("svelte")
setup_lsp("biome")
