local keymaps = {
  { "v",          "<A-Up>",     ":m '<-2<CR>gv=gv", { desc = 'Move selected line down' } },
  { "v",          "<A-Down>",   ":m '>+1<CR>gv=gv", { desc = 'Move selected line up' } },
  { "n",          "<A-Up>",     ":m .-2<CR>==",     { desc = 'Move current line up' } },
  { "n",          "<A-Down>",   ":m .+1<CR>==",     { desc = 'Move current line down' } },
  { "v",          "<Tab>",      ">gv",              { desc = 'indent by 1' } },
  { "n",          "<Tab>",      "v><C-\\><C-N>",    { desc = 'indent by 1' } },
  { "v",          "<S-Tab>",    "<gv",              { desc = 'indent by -1' } },
  { "n",          "<S-Tab>",    "v<<C-\\><C-N>",    { desc = 'indent by -1' } },
  { 'n',          '<C-Bs>',     'db',               { desc = "Delete previous word", noremap = true, silent = true } },
  { 'n',          '<C-Delete>', 'dw',               { desc = "Delete next word", noremap = true, silent = true } },
  { 'n',          '<C-A>',      'ggVG',             { desc = "Select all", noremap = true, silent = true } },
  { "n",          "J",          "mzJ`z",            { desc = 'Append next line to the current one' } },
  { "x",          "<leader>p",  [["_dP]],           { desc = 'Paste without losing buffer' } },
  { { "n", "v" }, "<leader>y",  [["+y]],            { desc = 'copy to system clipboard' } },
  { "n",          "<leader>Y",  [["+Y]],            { desc = 'copy to system clipboard' } },
  { "n",          "Q",          "<nop>" },
  {
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = 'Replace text under cursor with regex' }
  },
  {"n","<leader>pv","<cmd>Ex<cr>"},
}
for _, value in pairs(keymaps) do
  vim.keymap.set(value[1], value[2], value[3], value[4])
end
