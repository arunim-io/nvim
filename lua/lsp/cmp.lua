local lsp_zero = require 'lsp-zero'
local luasnip = require 'luasnip'

lsp_zero.extend_cmp()

local cmp = require 'cmp'

local function has_words_before()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function cmp_tab_completion(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end

local function cmp_shift_tab_completion(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup {
  formatting = lsp_zero.cmp_format(),
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, { { name = 'buffer' } }),
  mapping = cmp.mapping.preset.insert {
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping(cmp_tab_completion, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(cmp_shift_tab_completion, { "i", "s" }),
  }
}
