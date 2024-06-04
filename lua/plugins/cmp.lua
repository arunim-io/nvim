return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = "rafamadriz/friendly-snippets",
    init = function()
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.filetype_extend("python", { "django" })
      luasnip.filetype_extend("htmldjango", { "djangohtml", "djangohtml" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    opts = function()
      local cmp, luasnip = require("cmp"), require("luasnip")

      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
      }
    end,
  },
}
