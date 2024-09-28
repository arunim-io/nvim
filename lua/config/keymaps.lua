vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlights on search when pressing <Esc>" })

vim.keymap.set("v", "<C-S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selected line down" })
vim.keymap.set("v", "<C-S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selected line up" })
vim.keymap.set("n", "<C-S-Up>", ":m .-2<CR>==", { desc = "Move current line up" })
vim.keymap.set("n", "<C-S-Down>", ":m .+1<CR>==", { desc = "Move current line down" })

vim.keymap.set("v", "<Tab>", ">gv", { desc = "indent by 1" })
vim.keymap.set("n", "<Tab>", "v><C-\\><C-N>", { desc = "indent by 1" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "indent by -1" })
vim.keymap.set("n", "<S-Tab>", "v<<C-\\><C-N>", { desc = "indent by -1" })

vim.keymap.set("n", "<C-A>", "ggVG", { desc = "Select all words in current buffer", noremap = true, silent = true })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without losing buffer" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "copy to system clipboard" })

if nixCats("language-support.lsp") then
  vim.api.nvim_create_autocmd("LspAttach", {
    group = require("config.language-support.servers").lsp_augroup,
    callback = function(event)
      local function set(key, action, desc)
        vim.keymap.set("n", key, action, { buffer = event.buf, desc = "LSP: " .. desc, noremap = true })
      end

      local maps = vim.lsp.buf

      set("K", maps.hover, "[H]over documentation")
      set("gs", maps.signature_help, "[S]ignature Help")

      set("gd", maps.definition, "[G]o to [D]efinition")
      set("gD", maps.declaration, "[G]o to [D]eclaration")
      set("gi", maps.implementation, "[G]o to [I]mplementation")
      set("gt", maps.type_definition, "[G]o to [T]ype definition")
      set("gr", maps.references, "[G]o to [R]eferences")

      set("<leader>ca", maps.code_action, "[C]ode [A]ction")
      set("<leader>rn", maps.rename, "[R]ename")
    end,
  })
end
