return {
  "saghen/blink.cmp",
  name = "blink-cmp",
  lazy = false,
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "v0.*",
  --- @type blink.cmp.Config
  opts = {
    highlight = { use_nvim_cmp_as_default = true },
    keymap = { preset = "enter" },
    accept = { auto_brackets = { enabled = true } },
    trigger = { signature_help = { enabled = true } },
    sources = {
      completion = {
        enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
      },
      providers = {
        lsp = {
          -- dont show LuaLS require statements when lazydev has items
          fallback_for = { "lazydev" },
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
        },
      },
    },
  },
}
