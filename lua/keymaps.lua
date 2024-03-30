local keymaps = {
  { "v", "<S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selected line down" } },
  { "v", "<S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selected line up" } },
  { "n", "<S-Up>", ":m .-2<CR>==", { desc = "Move current line up" } },
  { "n", "<S-Down>", ":m .+1<CR>==", { desc = "Move current line down" } },
  { "v", "<Tab>", ">gv", { desc = "indent by 1" } },
  { "n", "<Tab>", "v><C-\\><C-N>", { desc = "indent by 1" } },
  { "v", "<S-Tab>", "<gv", { desc = "indent by -1" } },
  { "n", "<S-Tab>", "v<<C-\\><C-N>", { desc = "indent by -1" } },
  { "n", "<C-A>", "ggVG", { desc = "Select all", noremap = true, silent = true } },
  { "x", "<leader>p", [["_dP]], { desc = "Paste without losing buffer" } },
  { { "n", "v" }, "<leader>y", [["+y]], { desc = "copy to system clipboard" } },
  { "n", "<leader>Y", [["+Y]], { desc = "copy to system clipboard" } },
  { "n", "Q", "<nop>" },
  {
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace text under cursor with regex" },
  },
  { "n", "<C-Left>", "<C-w>h", { desc = "Move to left window", noremap = true, silent = true } },
  { "n", "<C-Down>", "<C-w>j", { desc = "Move to bottom window", noremap = true, silent = true } },
  { "n", "<C-Up>", "<C-w>k", { desc = "Move to top window", noremap = true, silent = true } },
  { "n", "<C-Right>", "<C-w>l", { desc = "Move to right window", noremap = true, silent = true } },
  { "n", "<leader>v", "<C-w>v", { desc = "Split window vertically", noremap = true, silent = true } },
  { "n", "<leader>h", "<C-w>s", { desc = "Split window horizontally", noremap = true, silent = true } },
}

for _, value in ipairs(keymaps) do
  vim.keymap.set(value[1], value[2], value[3], value[4])
end
