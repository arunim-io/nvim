return {
  "saghen/blink.cmp",
  name = "blink-cmp",
  lazy = false,
  dependencies = { "rafamadriz/friendly-snippets", "echasnovski/mini.icons" },
  version = "v0.*",
  --- @type blink.cmp.Config
  opts = {
    highlight = { use_nvim_cmp_as_default = true },
    keymap = { preset = "enter" },
    accept = { auto_brackets = { enabled = true } },
    trigger = { signature_help = { enabled = true } },
  },
}
