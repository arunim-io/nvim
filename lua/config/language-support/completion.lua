local cmp = require("cmp")

if nixCats("git") then
  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "git" },
    }, {
      { name = "buffer" },
    }),
  })
  require("cmp_git").setup()
end

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
  ---@diagnostic disable-next-line: missing-fields
  matching = { disallow_symbol_nonprefix_matching = false },
})

--- @type cmp.SourceConfig[]
local sources = {}

if nixCats("language-support.lsp") then
  table.insert(sources, { name = "nvim_lsp" } --[[@as cmp.SourceConfig]])

  if pcall(require, "lazydev") then
    table.insert(sources, { name = "lazydev", group_index = 0 } --[[@as cmp.SourceConfig]])
  end
end
if nixCats('language-support.snippets') then
  table.insert(sources, { name = "luasnip" } --[[@as cmp.SourceConfig]])
end

--- @type cmp.ConfigSchema
local config = {
  sources = cmp.config.sources(sources, { { name = "buffer" } }),
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
}

if nixCats('language-support.snippets') then
  vim.tbl_deep_extend('force', config, {
    snippet = {
      expand = function(args)
        require 'luasnip'.lsp_expand(args.body)
      end
    }
  } --[[@as cmp.ConfigSchema]])
end

cmp.setup(config)

if nixCats 'language-support.snippets' then
  require("luasnip.loaders.from_vscode").lazy_load()
end
