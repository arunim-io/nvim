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
  completion = {
    menu = {
      draw = {
        components = {
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              return icon
            end,
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
  signature = {
    enabled = true,
    trigger = { show_on_insert = true },
  },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      snippets = {
        should_show_items = function(ctx)
          return ctx.trigger.initial_kind ~= "trigger_character"
        end,
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
})
