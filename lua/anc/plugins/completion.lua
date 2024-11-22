--- @type LazySpec
return {
  "saghen/blink.cmp",
  name = "blink-cmp",
  lazy = false,
  dependencies = {
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      name = "luasnip",
      build = require("nixCatsUtils").lazyAdd("make install_jsregexp"),
      opts = {
        history = true,
        delete_check_events = "TextChanged",
      },
    },
    "saadparwaiz1/cmp_luasnip",
    { "saghen/blink.compat", name = "blink-compat", opts = { impersonate_nvim_cmp = true } },
  },
  version = "v0.*",
  --- @module 'blink-cmp'
  --- @type blink.cmp.Config
  opts = {
    highlight = { use_nvim_cmp_as_default = true },
    keymap = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      preset = "enter",
    },
    accept = {
      expand_snippet = require("luasnip").lsp_expand,
      auto_brackets = {
        enabled = true,
      },
    },
    trigger = {
      signature_help = {
        enabled = true,
      },
    },
    sources = {
      completion = {
        enabled_providers = { "lsp", "path", "luasnip", "buffer", "lazydev" },
      },
      providers = {
        luasnip = {
          name = "luasnip",
          module = "blink.compat.source",

          score_offset = -3,

          opts = {
            use_show_condition = false,
            show_autosnippets = true,
          },
        },
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
