require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.surround").setup()
require("mini.bracketed").setup()

require("mini.comment").setup({
  options = {
    custom_commentstring = function()
      return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
    end,
  },
})

local mini_files = require("mini.files")

mini_files.setup({
  options = { use_as_default_explorer = true },
  mappings = {
    synchronize = "s",
    go_in = "<Right>",
    go_out = "<Left>",
    go_in_plus = "",
    go_out_plus = "",
  },
})

vim.keymap.set("n", "<leader>pv", function()
  mini_files.open(nil, false)
end, { desc = "Show files explorer" })

local add = MiniDeps.add

add("folke/which-key.nvim")

require("which-key").setup({
  preset = "helix",
})

add("MagicDuck/grug-far.nvim")

local grug_far = require("grug-far")

grug_far.setup()

vim.keymap.set({ "n", "v" }, "<leader>rw", function()
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")

  grug_far.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    },
  })
end, { desc = "Search & replace" })

add("folke/trouble.nvim")

require("trouble").setup()

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  command = "Trouble qflist open",
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd("cclose")
        vim.cmd("Trouble qflist open")
      end)
    end
  end,
})

vim.keymap.set("n", "<leader>dq", "<cmd>Trouble qflist toggle<cr>", { desc = "Toggle quickfix list" })
vim.keymap.set(
  "n",
  "<leader>dw",
  "<cmd>Trouble diagnostics toggle<cr>",
  { desc = "Toggle diagnostics for current workspace" }
)
vim.keymap.set(
  "n",
  "<leader>db",
  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "Toggle diagnostics for current file" }
)
