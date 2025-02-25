MiniDeps.add({
  source = "saghen/blink.cmp",
  depends = { "rafamadriz/friendly-snippets", "saghen/blink.compat" },
  checkout = "v0.12.4",
})

local mini_snippets = require("mini.snippets")

mini_snippets.setup({
  snippets = { mini_snippets.gen_loader.from_lang() },
})

require("blink.cmp").setup({
  keymap = { preset = "enter" },
  cmdline = { enabled = false },
  snippets = { preset = "mini_snippets" },
  signature = {
    enabled = true,
    trigger = { show_on_insert = true },
  },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
})
