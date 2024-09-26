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

local sources = {
}

if nixCats("language-support.lsp") then
  table.insert(sources, { name = "nvim_lsp" })

  if pcall(require, "lazydev") then
    table.insert(sources, { name = "lazydev", group_index = 0 })
  end
end

cmp.setup({
  sources = cmp.config.sources(sources, {
    { name = "buffer" },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
})
