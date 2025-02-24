local function map(mode, keymap, cmd, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, keymap, cmd, opts)
end

-- [[ Search ]]
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear highlights on search when pressing <Esc>")

-- [[ Moving lines ]]
map("v", "<M-Up>", ":m '<-2<CR>gv=gv", "Move selected line down")
map("v", "<M-Down>", ":m '>+1<CR>gv=gv", "Move selected line up")
map("n", "<M-Up>", ":m .-2<CR>==", "Move current line up")
map("n", "<M-Down>", ":m .+1<CR>==", "Move current line down")

-- [[ Indent lines ]]
map("v", "<Tab>", ">gv", "indent by 1")
map("n", "<Tab>", "v><C-\\><C-N>", "indent by 1")
map("v", "<S-Tab>", "<gv", "indent by -1")
map("n", "<S-Tab>", "v<<C-\\><C-N>", "indent by -1")

-- [[ Clipboard ]]
map("x", "<leader>p", [["_dP]], "Paste without losing buffer")
map({ "n", "v" }, "<leader>y", [["+y]], "copy to system clipboard")
map("n", "<leader>Y", [["+Y]], "copy to system clipboard")
