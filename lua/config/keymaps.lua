local map = vim.keymap.set

-- move selected text up and down
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = 'Move selected line down' })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = 'Move selected line up' })
map("n", "<A-Up>", ":m .-2<CR>==", { desc = 'Move current line up' })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = 'Move current line down' })

-- delete word backkward
map('n', '<C-Bs>', 'db', { desc = "Delete previous word", noremap = true, silent = true })

-- delete word forward
map('n', '<C-Delete>', 'dw', { desc = "Delete next word", noremap = true, silent = true })

-- select all
map('n', '<C-A>', 'ggVG', { desc = "Select all", noremap = true, silent = true })

-- append next line to the current one
map("n", "J", "mzJ`z", { desc = 'Append next line to the current one' })

-- navigate while searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- paste without losing current buffer
map("x", "<leader>p", [["_dP]], { desc = 'Paste without losing buffer' })

-- paste to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

-- prevents from exiting
map("n", "Q", "<nop>")

-- quick list
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace the word under current cursor
map(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = 'Replace text under cursor with regex' }
)

-- make a script executable
map(
  "n",
  "<leader>x",
  "<cmd>!chmod +x %<CR>",
  { silent = true, desc = 'Make the script in current buffer executable' }
)
