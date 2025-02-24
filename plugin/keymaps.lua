local function map(mode, keymap, cmd, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, keymap, cmd, opts)
end

-- [[ Search ]]
map(
  "n",
  "gV",
  '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  "Visually select changed text",
  { expr = true, replace_keycodes = false }
)
map("x", "g/", "<esc>/\\%V", "Search inside visual selection", { silent = false })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear highlights on search when pressing <Esc>")

-- [[ Moving lines ]]
map("v", "<M-Up>", "<cmd>m '<-2<CR>gv=gv", "Move selected line down")
map("v", "<M-Down>", "<cmd>m '>+1<CR>gv=gv", "Move selected line up")
map("n", "<M-Up>", "<cmd>m .-2<CR>==", "Move current line up")
map("n", "<M-Down>", "<cmd>m .+1<CR>==", "Move current line down")

-- [[ Indent lines ]]
map("v", "<Tab>", ">gv", "indent by 1")
map("n", "<Tab>", "v><C-\\><C-N>", "indent by 1")
map("v", "<S-Tab>", "<gv", "indent by -1")
map("n", "<S-Tab>", "v<<C-\\><C-N>", "indent by -1")

-- [[ Copy/paste with system clipboard ]]
map({ "n", "v", "x" }, "gy", '"+y', "copy to system clipboard")
map("n", "gp", '"+p', "Paste from system clipboard")
map("x", "gp", '"+P', "Paste from system clipboard")
